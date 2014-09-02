//
//  resEditorAppDelegate.m
//  resEditor
//
//  Created by Stanislav on 7/29/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "resEditorAppDelegate.h"
#include "stdio.h"
#include "stdlib.h"


#include "parse.h"

@implementation resEditorAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	[window orderFront:self];
	[self openEditor:@"/Volumes/Data/Works/SDK_CS5.5/InPageRobot/source/ErrorHandling.fr"];
}

- (void) openEditor: (NSString *) inPath {
	[window orderFront:self];
	//open file
	FILE * fp;
	fp = fopen([inPath cStringUsingEncoding:NSUTF8StringEncoding], "r");
	if(fp == NULL)
		error("File not open");
	fseek(fp, 0, SEEK_END);
	long size = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	char * buf = malloc(size+1);
	size_t readSize = fread(buf, 1, size, fp);
	if(readSize != size){
		free(buf);
		error("Error read file");
	}
	buf[size] = '\0';
	resource_t * res_node = create_resource();;
	if(scan(buf)){		
		parseRes(res_node);
	}
	if(res_node->childs){
		MainWindowController * wc = [window windowController];
		NSMutableString * text = [[NSMutableString alloc] initWithCapacity:100];
		[self  show: res_node->childs->at(res_node->childs, 0) Text:text];
		[wc.custView setResourceNode:res_node->childs->at(res_node->childs, 0) ];
		
		[wc.textArea_ setStringValue:text];
	[text release];
	}	
	
	fclose(fp);	
	free(buf);
		
	[inPath release];
}
-(void) show: (resource_t *) res_node Text:(NSMutableString *) text  {
	static int tabs = 0;
	
	[text appendString:@"\n"];
	[self tabs:text TabNumber:tabs];
	[text appendFormat:@"name: %s\n", res_node->name ];
	[self tabs:text TabNumber:tabs];
	[text appendFormat:@"type: %s\n", res_node->type ];
	[self tabs:text TabNumber:tabs];
	[text appendFormat:@"Frame ( %d, %d, %d, %d )\n", res_node->_base.fr.left, res_node->_base.fr.top, res_node->_base.fr.right, res_node->_base.fr.bottom];
	
	if(res_node->childs){
		++tabs;
		for(int i = 0; i < res_node->childs->length; ++i){			
			[self show: (res_node->childs->at(res_node->childs, i)) Text:text];
		}
		--tabs;
	}
	
}

- (void) tabs : (NSMutableString*) text TabNumber:(int)x  {	
		while (x--)
			[text appendString:@"\t"];	
}

@end
