/*
 *  vector.h
 *  fc_scan
 *
 *  Created by Stanislav on 8/1/14.
 *  Copyright 2014 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef __vector_h_
#define __vector_h_

#include <stddef.h>

struct vector {
	void * data;
	void * (*at)(struct vector * self, unsigned int index);
	void (*add) (struct vector * self, void * element);
	void (*remove) (struct vector * self, unsigned int index);
	//
	void (*clean) (struct vector * self);
	
	size_t elem_size;
	size_t length;
	size_t capacity;
};

typedef struct vector vector_t;

vector_t * vector_init(size_t element_size);
void vector_free(vector_t * vector);

#endif