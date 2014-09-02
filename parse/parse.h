/*
 *  parse.h
 *  fc_scan
 *
 *  Created by Stanislav on 7/30/14.
 *  Copyright 2014 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef __parse_h__
#define __parse_h__
#include "model.h"

enum tokens {
	NUMBER = 'n', /* number*/	
	RESOURCE = 'r',
	FRAME = 'f',
	POINT = 'i',
	TYPE = 't',
	PUNCT = 'p',	/* start, end comments; separators and etc */
	CONST = 'c',	/* words starts with kXxxx (kPRTEBPassWidgetID) */
	UNDEF = 'u',
	CONTRL = 'o'
};


void error (const char * fmt, ...);
enum tokens scan(const char * buf);
void parseRes(resource_t * cur_node);
#endif __parse_h__