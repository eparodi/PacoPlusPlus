
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



void printObject(_object o) {
	switch(o->type->id) {
		case INTEGER:
			printf("%d", o->cont.num);
			break;
		case DECIMAL:
			printf("%f", o->cont.fl);
			break;
		case STR:
			printf("%s", o->cont.str);
			break;
	}
}
	int main() {
		var_table = createHashTable(sizeof(char *), sizeof(_object), &str_hash, 20, &str_eql);
		startTypes();
		buildOpTable();
printObject(dvnStrDec(createString("asd4.5asd4.5asd4.5"),createDecimal(4.500000f)));
printf("\n");
}