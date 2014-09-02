/*
 *  model.h
 *  fc_scan
 *
 *  Created by Stanislav on 7/31/14.
 *  Copyright 2014 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef __model_h__
#define __model_h__

#include "vector.h"

#define CHILD_TYPE struct resource_t
#define CHILD_SIZE sizeof (CHILD_TYPE)

enum binding {
	kBindNone,
	kBindLeft,
	kBindTop,
	kBindRight,
	kBindBottom,
	kBindNotSymetrize,
	kBindAll,
	kBindParentToChild
};

enum boolvalue{
	kTrue,
	kFalse
};

struct in_frame {
	int left;
	int top;
	int right;
	int bottom;
};

struct base_res {
	enum binding bind;
	struct in_frame fr;
	int visible;
	int enabled;	
};

typedef struct key_value_t {
	char * key;
	char * value;
} kay_value_t;

typedef struct resource_t {
	char name[50];
	char type[50];
	struct base_res _base;
	//childs
	vector_t * childs;
	//return created child
	CHILD_TYPE * (*add_child)(CHILD_TYPE * _self);
	//
	int * temp_value;	
}resource_t;


//init resourcse_t
resource_t * create_resource();
//
void resource_node_free(resource_t * node);
#endif 