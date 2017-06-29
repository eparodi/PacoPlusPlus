
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

		// INT INT OPERATIONS
		addOperation(&addIntInt,"addIntInt",INTEGER, INTEGER,ADD,getType(INTEGER));
		addOperation(&subIntInt,"subIntInt",INTEGER, INTEGER,SUB,getType(INTEGER));
		addOperation(&mulIntInt,"mulIntInt",INTEGER, INTEGER,MUL,getType(INTEGER));
		addOperation(&dvnIntInt,"dvnIntInt",INTEGER, INTEGER,DVN,getType(INTEGER));
		addOperation(&powIntInt,"powIntInt",INTEGER, INTEGER,PWR,getType(INTEGER));

		// DECIMAL DECIMAL OPERATIONS		
		addOperation(&addDecDec,"addDecDec",DECIMAL, DECIMAL,ADD,getType(DECIMAL));
		addOperation(&subDecDec,"subDecDec",DECIMAL, DECIMAL,SUB,getType(DECIMAL));
		addOperation(&mulDecDec,"mulDecDec",DECIMAL, DECIMAL,MUL,getType(DECIMAL));
		addOperation(&dvnDecDec,"dvnDecDec",DECIMAL, DECIMAL,DVN,getType(DECIMAL));

		// INT DECIMAL OPERATIONS		
		addOperation(&addIntDec,"addIntDec",INTEGER, DECIMAL,ADD,getType(DECIMAL));
		addOperation(&subIntDec,"subIntDec",INTEGER, DECIMAL,SUB,getType(DECIMAL));
		addOperation(&mulIntDec,"mulIntDec",INTEGER, DECIMAL,MUL,getType(DECIMAL));
		addOperation(&dvnIntDec,"dvnIntDec",INTEGER, DECIMAL,DVN,getType(DECIMAL));

		// DECIMAL INT OPERATIONS		
		addOperation(&addDecInt,"addDecInt",DECIMAL, INTEGER,ADD,getType(DECIMAL));
		addOperation(&subDecInt,"subDecInt",DECIMAL, INTEGER,SUB,getType(DECIMAL));
		addOperation(&mulDecInt,"mulDecInt",DECIMAL, INTEGER,MUL,getType(DECIMAL));
		addOperation(&dvnDecInt,"dvnDecInt",DECIMAL, INTEGER,DVN,getType(DECIMAL));

		// STRING STRING OPERATIONS		
		addOperation(&addStrStr,"addStrStr",STR, STR,ADD,getType(STR));
		addOperation(&subStrStr,"subStrStr",STR, STR,SUB,getType(STR));
		addOperation(&mulStrStr,"mulStrStr",STR, STR,MUL,getType(STR));
		addOperation(&dvnStrStr,"dvnStrStr",STR, STR,DVN,getType(STR));

		// STRING INT OPERATIONS		
		addOperation(&addStrInt,"addStrInt",STR, INTEGER,ADD,getType(STR));
		addOperation(&subStrInt,"subStrInt",STR, INTEGER,SUB,getType(STR));
		addOperation(&mulStrInt,"mulStrInt",STR, INTEGER,MUL,getType(STR));
		addOperation(&dvnStrInt,"dvnStrInt",STR, INTEGER,DVN,getType(STR));

		// INT STRING OPERATIONS		
		addOperation(&addIntStr,"addIntStr",INTEGER, STR,ADD,getType(STR));
		addOperation(&subIntStr,"subIntStr",INTEGER, STR,SUB,getType(STR));
		addOperation(&mulIntStr,"mulIntStr",INTEGER, STR,MUL,getType(STR));
		addOperation(&dvnIntStr,"dvnIntStr",INTEGER, STR,DVN,getType(STR));
printObject(addIntInt(createInt(2),createInt(2)));
printf("\n");
printObject(addIntInt(createInt(5),createInt(4)));
printf("\n");
printObject(addDecInt(createDecimal(4.500000f),createInt(5)));
printf("\n");
printObject(dvnDecInt(createDecimal(9.000000f),createInt(6)));
printf("\n");
printObject(addStrStr(createString("asd"),createString("DSA")));
printf("\n");
printObject(addStrInt(createString("asd"),createInt(789)));
printf("\n");
printObject(mulIntStr(createInt(4),createString("b")));
printf("\n");
printObject(mulStrStr(createString("OOOO"),createString("qwe")));
printf("\n");
printObject(dvnStrStr(createString("holaBORRAME comBORRAMEo va?"),createString("BORRAME")));
printf("\n");
printObject(dvnStrInt(createString("Pe123456dro"),createInt(123456)));
printf("\n");
}