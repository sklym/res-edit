/*
 *  parse.c
 *  fc_scan
 *
 *  Created by Stanislav on 7/30/14.
 *  Copyright 2014 envion. All rights reserved.
 *
 */


#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <assert.h>
#include <stdarg.h>
#include <string.h>

#include "vector.h"

#include "parse.h"


#define ALNUM	"ABCDEFGHIJKLMNOPQRSTUVWXYZ" \
				"abcdefghijklmnopqrstuvwxyz" \
				"_" "0123456789"


#define BUFSIZE 100
#define RESOURCE_KEY "resource"
#define FRAME_KEY "Frame"
#define POINT_KEY "PMPoint"
#define TYPE_KEY "type"

#define RESOURCE_PNGA "PNGA"
#define RESOURCE_PNGR "PNGR"
#define RESOURCE_STRING_TABLE "StringTable"

#define TEST_FILE "/Volumes/Data/Works/SDK_CS5.5/InPageRobot/source/TasksDialog.fr"//ErrorHandling.fr"



typedef void (*parse_func_ptr) (resource_t * cur_node);

static double number;
static enum tokens token;
static const char * symbol;
static char tempBuf[BUFSIZE];
static int gotoEndStr = 0;


void static_text_widget_parser(resource_t * cur_node);
void process_widgets(resource_t * cur_node);
void parse_frame(resource_t * cur_node);
enum tokens lex(const char * buf);
void process();
const char * getSymbol(const char * buf);
void comments();

void show_node(resource_t * cur_node);

void set_frame(resource_t * cur_node, vector_t * valies, int *start_index);
void parse_block(resource_t * cur_node, vector_t * values);
void parse_childs(resource_t * cur_node, vector_t * values);
void parse_resource(resource_t * cur_node);
void parse_value(resource_t * cur_node, vector_t * values);
/*
 * scan
 */
enum tokens scan_t(const char * buf){
	static const char * bp;
	if (buf) 
		bp = buf;
	//comments use case
	while(gotoEndStr){		
		if(* bp == '\n'){
			++ bp , gotoEndStr = 0, token = CONTRL;
			return token;
		} else if(* bp == '\r'){
			if(* (bp + 1) == '\n'){
				bp += 2, gotoEndStr = 0;
			} else {
				++ bp , gotoEndStr = 0;	
			}
			token = CONTRL;
			return token;
		} else
			++ bp;
	}
	
	while (isspace(* bp & 0xff))
		++ bp;
	if(isdigit(* bp & 0xff)){
		token = NUMBER, number = strtod(bp, (char **) &bp);		
	} else if (isalpha(* bp & 0xff) || * bp == '_'){
		char buff[BUFSIZE];
		int len = strspn(bp, ALNUM);
		if (len >= BUFSIZ)
			error("name too long: %-.10s...", bp);
		strncpy(buff, bp, len), buff[len] = '\0', bp += len, token = lex(buff);
		symbol = getSymbol(buff);
	} else 
		token = * bp ? * bp ++ : 0;	

	return token;
}

enum tokens scan(const char * buf){
	scan_t(buf);
	if(token == '/'){
		comments();
		scan(0);
	} else if(token == '#'){
		gotoEndStr = 1;
		scan(0);
	} else if(token == CONTRL)
		scan(0);
	return token;
}

enum tokens lex(const char * buf){
	if(*buf == 'k')
		return CONST;
	else if(strcmp(buf, RESOURCE_KEY) == 0 )
		return RESOURCE;
	else if (strcmp(buf, FRAME_KEY) == 0)
		return FRAME;
	else if(strcmp(buf, TYPE_KEY) == 0)
		return TYPE;
	else if(strcmp(buf, "__FILE__") == 0 || strcmp(buf, "__LINE__") == 0)
		return CONST;
	else if(strcmp(buf, POINT_KEY) == 0)
		return POINT;
	return UNDEF;
}

const char * getSymbol(const char * buf){		
	strcpy(tempBuf, buf);
	return tempBuf;
}

void comments(){
	if(token == '/'){
		scan_t(0);
		if(token == '*'){
			scan_t(0);
			while (token != '/') {										
				while(token != '*')
					scan_t(0);
				scan_t(0);
			}
			
		} else if(token == '/'){
			gotoEndStr = 1;
			scan_t(0);			
		}		
	}
}


void undef_widget_parser(resource_t * cur_node, const char * type){
	resource_t * child = cur_node->add_child(cur_node);
	strcpy(child->name, "CommonWidget");
	strcpy(child->type, type);
	vector_t * values = vector_init(sizeof(int));
	scan(0);
	parse_block(child, values);
	
	/**BODY**/
	// widget ID
	int index = 3;	
	
	set_frame(child, values, &index);//  left, top, right, bottom, visible, enabled
	vector_free(values);
}

/*
 * Frame
 */
void set_frame(resource_t * cur_node, vector_t * valies, int *start_index){
	//Frame					
	cur_node->_base.fr.left = *(int*)valies->at(valies, *start_index);
	cur_node->_base.fr.top = *(int*)valies->at(valies, ++(*start_index) );
	cur_node->_base.fr.right = *(int*)valies->at(valies, ++(*start_index));
	cur_node->_base.fr.bottom = *(int*)valies->at(valies, ++(*start_index));
	cur_node->_base.visible = *(int*)valies->at(valies, ++(*start_index));
	cur_node->_base.enabled = *(int*)valies->at(valies, ++(*start_index));	
}

void resource_dialog_parse(resource_t * cur_node){
	
	if(token == UNDEF){		
		strcpy(cur_node->name, symbol);	
	}
	strcpy(cur_node->type, "DialogWidget");
	//dialog id 
	scan(0);
	if(token != '(')
		error("expected (");
	while(scan(0) != ')');
	//resource body
	vector_t * values = vector_init(sizeof(int));
	scan(0);
	parse_childs(cur_node, values);
	/***BODY***/
		
	if(token != ';')
		if(scan(0) != ';')
			error("expected ;");
	int index = 5;
	set_frame(cur_node, values, &index);
	vector_free(values);
	
}


void parseRes(resource_t * cur_node){
	do {
		switch (token){
			case RESOURCE:
				parse_resource(cur_node);
				break;			
			case TYPE: //ignore while
				while(scan(0) != ';');
				break;
			default:
				error("%c, expected: resource or type", token);
		}	
	} while(token && scan(0));
}

static int sign = 1;
void parse_value(resource_t * cur_node, vector_t * values){	
	int v = 0;
	switch(token){
		case CONST:			
			if(strcmp(symbol,"kTrue") == 0)						
				v = 1, values->add(values, &v); 
			else if(strcmp(symbol,"kFalse") == 0)
				v = 0, values->add(values, &v); 
			else {
				fprintf(stdout, "not found %s \n", symbol);
				v = -1, values->add(values, &v);
			}
			break;
		case NUMBER:
			v = (int)number,v *=sign, values->add(values, &v),sign = 1;;
			break;
		case '\"':	//String const
			/*static text -  temp ignore value*/
			while(scan(0) != '\"');	
			v = -2, values->add(values, &v);
			break;
		case POINT:
		case FRAME:
			scan(0);
			parse_block(cur_node, values);
			scan(0);
			if(token == ',')
				scan(0);
			parse_value(cur_node, values);//after Frame(,,,) dont go ,
			break;
		case '-':
			sign = -1;
			scan(0);
			parse_value(cur_node, values);
			break;
		case '|':
			//while ignore
			scan(0);
			break;
		default:
			error("%c, expected NUMBER, CONST,FRAME or STRING CONST", token);
	}
}

//1h
void parse_block(resource_t * cur_node, vector_t * values){
	
	switch(token){
		case '(':
			scan(0);
			parse_value(cur_node, values);
			break;
		
		case ')': //end block		
			return ;		
		case ',':
			scan(0);
			if(token == ')' || token == '}')
				return;
			if(token == '{'){
				scan(0);
				parse_childs(cur_node, values);
				break;
			}
			parse_value(cur_node, values);			
			break;
		case '{':
			scan(0);
			parse_childs(cur_node, values);
			break;
		case '}':
			return;
		case '|':
			parse_value(cur_node, values);			
			break;
		default:
			error("%c, expected (,) Frame ", token);
			
	}
	scan(0);
	parse_block(cur_node, values);	
}
//2h
void parse_childs(resource_t * cur_node, vector_t * values){
	
	switch(token){
		case '{': //values
			scan(0);
			if(token == '}')
				break;
			parse_value(cur_node, values);
			scan(0);
			parse_block(cur_node, values);
			break;
		case UNDEF: //new widget
			undef_widget_parser(cur_node, symbol);						
			break;
		case '}': //end block
		case ';':
			return;
		case ',':
			break;
		default:
			error("%c, excepted {, }; WIDGET", token);
	}
	scan(0);
	parse_childs(cur_node, values);
}

void parse_resource(resource_t * cur_node){
	scan(0);
	if(strcmp(symbol, RESOURCE_PNGA) == 0 ||
	   strcmp(symbol, RESOURCE_PNGR) == 0){
		while (scan(0) != '\"');
		while (scan(0) != '\"');
		return;
	} else if(strcmp(symbol, RESOURCE_STRING_TABLE) == 0){
		
	}
	resource_t * child = cur_node->add_child(cur_node);
	resource_dialog_parse(child);
}
void string_table_parse(){
	
}
/*
 * error
 */
void error (const char * fmt, ...)
{	va_list ap;
	
	va_start(ap, fmt);
	vfprintf(stderr, fmt, ap), putc('\n', stderr);
	va_end(ap);	
	assert(0);
}