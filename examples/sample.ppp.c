
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
printObject(createString("Adding number and number:"));
printf("\n");
printObject(addIntInt(createInt(2),createInt(2)));
printf("\n");
printObject(createString("Adding number and decimal:"));
printf("\n");
printObject(addDecInt(createDecimal(4.500000f),createInt(5)));
printf("\n");
printObject(createString("Dividing decimal and number:"));
printf("\n");
printObject(dvnDecInt(createDecimal(9.000000f),createInt(6)));
printf("\n");
printObject(createString("Adding strings:"));
printf("\n");
printObject(addStrStr(createString("asd"),createString("DSA")));
printf("\n");
printObject(createString("Adding string and number:"));
printf("\n");
printObject(addStrInt(createString("asd"),createInt(789)));
printf("\n");
printObject(createString("Multiplying number and string"));
printf("\n");
printObject(mulIntStr(createInt(4),createString("ravioles")));
printf("\n");
printObject(createString("Multiplying string and string:"));
printf("\n");
printObject(mulStrStr(createString("1234"),createString("abc")));
printf("\n");
printObject(createString("Dividing string and string"));
printf("\n");
printObject(dvnStrStr(createString("holaBORRAME comBORRAMEo va?"),createString("BORRAME")));
printf("\n");
printObject(createString("Dividing string and number"));
printf("\n");
printObject(dvnStrInt(createString("Pe123456dro"),createInt(123456)));
printf("\n");
printObject(createString("Creating list:"));
printf("\n");
_object var1=newList();
printObject(var1);
printf("\n");
addList(var1->cont.obj,createInt(5534));
addList(var1->cont.obj,createDecimal(55.500000f));
addList(var1->cont.obj,createString("qwerty"));
printObject(var1);
printf("\n");
printObject(createString("Multiplying two lists:"));
printf("\n");
printObject(multAnyList(var1,var1));
printf("\n");
}