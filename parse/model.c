/*
 *  model.c
 *  fc_scan
 *
 *  Created by Stanislav on 7/31/14.
 *  Copyright 2014 __MyCompanyName__. All rights reserved.
 *
 */
#include <stdlib.h>

#include "model.h"



CHILD_TYPE * resource_node_add_child(resource_t * self){
	
	if(!self->childs){
		self->childs = vector_init(CHILD_SIZE);
	}
	resource_t * child = create_resource();
	self->childs->add(self->childs, child);	
	free(child);
	return (CHILD_TYPE *) self->childs->at(self->childs, self->childs->length - 1);
}

resource_t * create_resource(){
	resource_t * new_res = malloc(sizeof(resource_t));
	new_res->childs = NULL;
	new_res->temp_value = NULL;
	new_res->add_child = resource_node_add_child;
	return new_res;
}

void resource_childs_free(resource_t * node){
	vector_t * childs = node->childs;
	if(childs){
		for(int i = 0; i < childs->length; ++i)
			resource_childs_free(childs->at(childs, i));
		childs->clean(childs);
		vector_free(childs);
	}
}

void resource_node_free(resource_t * node){		
	resource_childs_free(node);	
	free(node);
}


