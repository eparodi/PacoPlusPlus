
	#include <stdio.h>
	#include <stdlib.h>
	#include <math.h>
	#include <string.h>
	#include "operations/include/operations.h"
	#include "types/include/object.h"
	#include "types/include/types.h"
	#include "hashtable/include/hashtable.h"
	#include "yaccObjects.h"


	hashTableT var_table;

	static unsigned int str_hash(char* key);
	static unsigned int str_eql(const char * s1, const char * s2);

	static unsigned int str_hash(char* key){
		unsigned int h = 5381;
		while(*(key++))
			h = ((h << 5) + h) + (*key);
		return h;
	}

	static unsigned int str_eql(const char * s1, const char * s2){
	  return strcmp(s1,s2) == 0;
	}



	int main() {
		var_table = createHashTable(sizeof(char *), sizeof(_object), &str_hash, 20, &str_eql);
		startTypes();
		buildOpTable();
printObject(addIntInt(createInt(1),createInt(1)));
printf("\n");
printObject(addIntInt(createInt(5),createInt(5)));
printf("\n");
}