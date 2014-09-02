/*
 *  vector.c
 *  fc_scan
 *
 *  Created by Stanislav on 8/1/14.
 *  Copyright 2014 __MyCompanyName__. All rights reserved.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#include "vector.h"

/*
 * vector_init
 */
void * vector_at(struct vector * self, unsigned int index);
void vector_add (struct vector * self, void * element);
void vector_remove (struct vector * self, unsigned int index);
void vector_clean (struct vector * self);

vector_t * vector_init(size_t element_size){
	vector_t * new_vector = malloc(sizeof(vector_t));
	new_vector->capacity = 3;
	new_vector->elem_size = element_size;
	new_vector->length = 0;
	new_vector->at = vector_at;
	new_vector->add = vector_add;
	new_vector->remove = vector_remove;
	new_vector->data = malloc(new_vector->elem_size*new_vector->capacity);
	new_vector->clean = vector_clean;
	return new_vector;
}
/*
 * vector_free
 */
void vector_free(vector_t * vector){
	if(vector){
		if(vector->data)
			free(vector->data);
		free(vector);
	}
	
}

void * vector_at(struct vector * self, unsigned int index){
	if(self){
		if(index < self->length)
			return (self->data + self->elem_size*index);
	}
	return NULL;
}


void vector_add (struct vector * self, void * element){
	assert(self);
	if(self->capacity == self->length){
		/*reallocate new memory*/
		size_t new_size = self->capacity*2;
		self->data = realloc(self->data, new_size * self->elem_size);
		assert(self->data);
		self->capacity = new_size;
	}
	memcpy((self->data + self->length*self->elem_size), element, self->elem_size);
	++self->length;
}

void vector_remove (struct vector * self, unsigned int index){
	if(self){
		size_t shift = self->length - index - 1;
		if(shift > 0){
			for(int i = index; i < self->length-1; ++i){
				memcpy((self->data + i*self->elem_size ), (self->data + (i+1)*self->elem_size ), self->elem_size);
			}			
		}
		--self->length;
	}
}

void vector_clean (struct vector * self){
	self->length = 0;
}