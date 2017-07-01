#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "include/operations.h"

void removeZeros(char * str);


_object createInt(int num) {
	_object o = malloc(sizeof(Object));
	if (!o) {
		return NULL;
	}
	o->type = getType(INTEGER);
	o->cont.num = num;
	return o;
}

_object createDecimal(float num) {
	_object o = malloc(sizeof(Object));
	if (!o) {
		return NULL;
	}
	o->type = getType(DECIMAL);
	o->cont.fl = num;
	return o;
}

_object createString(char * str) {
	_object o = malloc(sizeof(Object));
	if (!o) {
		return NULL;
	}
	o->type = getType(STR);
	o->cont.str = malloc(strlen(str) + 1);
	strcpy(o->cont.str, str);
	return o;
}

_object powIntInt(_object o1, _object o2) {
	return createInt((int) pow(o1->cont.num, o2->cont.num));
}


// ------------------------ AUX FUNCTIONS ------------------------------

int digitCount(int n) {
	int count = 0;
	while (n != 0) {
		n /= 10;
		++count;
	}
	return count;
}

void invertStr(char * str) {
	int i = 0, j = strlen(str) - 1;
	while (i < j) {
		char auxc = str[i];
		str[i] = str[j];
		str[j] = auxc;
		i++;
		j--;
	}
}

char * multiplyString(char * str, float f) {
	int len = strlen(str) * f;
	char* aux = calloc(1, len + 1);
	int n = (int) floor(f);
	while (n-- > 0) {
		strcat(aux, str);
	}
	n = (int)((f - floor(f)) * strlen(str));
	if (n > 0) {
		strncat(aux, str, n);
	}
	return aux;
}

char * itoa(int n) {
	char * intStr = calloc(1, digitCount(n) + 1);
	sprintf(intStr, "%d", n);
	return intStr;
}

char * floatToString(float f) {
	char * fStr = calloc(1, digitCount((int)f)+8);
	sprintf(fStr, "%f", f);
	removeZeros(fStr);
	return fStr;
}

void removeZeros(char * str) {
	int i = strlen(str) - 1;
	while(str[i] == '0' && i > 0) {
		str[i--] = '\0';
	}
}

/*
 * Assigns to dest a pointer to the string str without any substring substr
 */
void deleteSubstr(char * str, char * substr, char * dest) {
	int i = 0, j = 0, k = 0;
	int startSubstr = -1;
	int substrLen = strlen(substr);

	if (substrLen <= 0) {
		strcpy(dest, str);
		return;
	}

	while (str[i] != 0) {
		dest[k] = str[i];
		if (str[i] == substr[j]) {
			if (startSubstr == -1) {
				startSubstr = k;
			}
			if (k - startSubstr + 1 == substrLen) {
				j = 0;
				k = startSubstr - 1;
				startSubstr = -1;
			} else {
				j++;
			}
		}
		i++;
		k++;
	}
	dest[k] = '\0';
}

void loadOperations() {
	printf("Loading operations\n");
			// SUM OPERATIONS
		addOperation(&addIntInt,"addIntInt",INTEGER, INTEGER,ADD,getType(INTEGER));
		addOperation(&addIntStr,"addIntStr",INTEGER, STR,ADD,getType(STR));
		addOperation(&addIntDec,"addIntDec",INTEGER, DECIMAL,ADD,getType(DECIMAL));
		//addOperation(&addIntArr,"addIntArr",INTEGER, ARRAY?,ADD,getType(?));

		addOperation(&addStrInt,"addStrInt",STR, INTEGER,ADD,getType(STR));
		addOperation(&addStrStr,"addStrStr",STR, STR,ADD,getType(STR));
        addOperation(&addStrDec,"addStrDec",STR, DECIMAL,ADD,getType(STR));
        //addOperation(&addStrArr,"addStrArr",STR, ARRAY,ADD,?);

		addOperation(&addDecInt,"addDecInt",DECIMAL, INTEGER,ADD,getType(DECIMAL));
		addOperation(&addDecStr,"addDecStr",DECIMAL, STR,ADD,getType(STR));
		addOperation(&addDecDec,"addDecDec",DECIMAL, DECIMAL,ADD,getType(DECIMAL));
        //addOperation(&addDecArr,"addDecArr",DECIMAL, ARRAY?,ADD,getType(?));

        //addOperation(&addArrInt,"addArrInt",ARRAY, INTEGER,ADD,getType(?));
        //addOperation(&addArrStr,"addArrStr",ARRAY, STR,ADD,getType(?));
        //addOperation(&addArrDec,"addArrDec",ARRAY, DECIMAL,ADD,getType(?));
        //addOperation(&addArrArr,"addArrArr",ARRAY, ARRAY,ADD,getType(?));
		addOperation(&subStrStr,"subStrStr",STR, STR,SUB,getType(STR));


        // SUB OPERATIONS
		addOperation(&subIntInt,"subIntInt",INTEGER, INTEGER,SUB,getType(INTEGER));
		addOperation(&subIntStr,"subIntStr",INTEGER, STR,SUB,getType(STR));
		addOperation(&subIntDec,"subIntDec",INTEGER, DECIMAL,SUB,getType(DECIMAL));
		//addOperation(&subIntArr,"subIntArr",INTEGER, ARRAY,SUB,getType(?));

		addOperation(&subDecInt,"subDecInt",DECIMAL, INTEGER,SUB,getType(DECIMAL));
		addOperation(&subDecStr,"subDecStr",DECIMAL, STR,SUB,getType(STR));
		addOperation(&subDecDec,"subDecDec",DECIMAL, DECIMAL,SUB,getType(DECIMAL));
		//addOperation(&subDecArr,"subDecArr",DECIMAL, ARRAY,SUB,getType(?));

		addOperation(&subStrInt,"subStrInt",STR, INTEGER,SUB,getType(STR));
		addOperation(&subStrStr,"subStrStr",STR, STR,SUB,getType(STR));
		addOperation(&subStrDec,"subStrDec",STR, DECIMAL,SUB,getType(STR));
		//addOperation(&subStrArr,"subStrArr",STR, ARRAY,SUB,getType(?));

		//addOperation(&subArrInt,"subArrInt",ARRAY, INTEGER,SUB,getType(?));
        //addOperation(&subArrStr,"subArrStr",ARRAY, STR,SUB,getType(?));
        //addOperation(&subArrDec,"subArrDec",ARRAY, DECIMAL,SUB,getType(?));
        //addOperation(&subArrArr,"subArrArr",ARRAY, ARRAY,SUB,getType(?));


        // MUL OPERATIONS
		addOperation(&mulIntInt,"mulIntInt",INTEGER, INTEGER,MUL,getType(INTEGER));
		addOperation(&mulIntStr,"mulIntStr",INTEGER, STR,MUL,getType(STR));
		addOperation(&mulIntDec,"mulIntDec",INTEGER, DECIMAL,MUL,getType(DECIMAL));
		//addOperation(&mulIntArr,"mulIntArr",INTEGER, ARRAY,MUL,getType(?));

		addOperation(&mulStrInt,"mulStrInt",STR, INTEGER,MUL,getType(STR));
		addOperation(&mulStrStr,"mulStrStr",STR, STR,MUL,getType(STR));
		addOperation(&mulStrDec,"mulStrDec",STR, DECIMAL,MUL,getType(STR));
		//addOperation(&mulStrArr,"mulStrArr",STR, ARRAY,MUL,getType(?));

		addOperation(&mulDecInt,"mulDecInt",DECIMAL, INTEGER,MUL,getType(DECIMAL));
		addOperation(&mulDecStr,"mulDecStr",DECIMAL, STR,MUL,getType(STR));
		addOperation(&mulDecDec,"mulDecDec",DECIMAL, DECIMAL,MUL,getType(DECIMAL));
		//addOperation(&mulDecArr,"mulDecArr",DECIMAL, ARRAY,MUL,getType(?));

		//addOperation(&mulArrInt,"mulArrInt",ARRAY, INTEGER,MUL,getType(?));
        //addOperation(&mulArrStr,"mulArrStr",ARRAY, STR,MUL,getType(?));
        //addOperation(&mulArrDec,"mulArrDec",ARRAY, DECIMAL,MUL,getType(?));
        //addOperation(&mulArrArr,"mulArrArr",ARRAY, ARRAY,MUL,getType(?));

		// DVN OPERATIONS
		addOperation(&dvnIntInt,"dvnIntInt",INTEGER, INTEGER,DVN,getType(INTEGER));
		addOperation(&dvnIntStr,"dvnIntStr",INTEGER, STR,DVN,getType(STR));
		addOperation(&dvnIntDec,"dvnIntDec",INTEGER, DECIMAL,DVN,getType(DECIMAL));

		addOperation(&dvnStrInt,"dvnStrInt",STR, INTEGER,DVN,getType(STR));
		addOperation(&dvnStrStr,"dvnStrStr",STR, STR,DVN,getType(STR));
		addOperation(&dvnStrDec,"dvnStrDec",STR, DECIMAL,DVN,getType(STR));
		//addOperation(&dvnStrArr,"dvnStrArr",STR, ARRAY,DVN,getType(?));

		addOperation(&dvnDecInt,"dvnDecInt",DECIMAL, INTEGER,DVN,getType(DECIMAL));
		addOperation(&dvnDecStr,"dvnDecStr",DECIMAL, STR,DVN,getType(STR));
		addOperation(&dvnDecDec,"dvnDecDec",DECIMAL, DECIMAL,DVN,getType(DECIMAL));
		//addOperation(&dvnDecArr,"dvnDecArr",DECIMAL, ARRAY,DVN,getType(?));

		//addOperation(&dvnArrInt,"dvnArrInt",ARRAY, INTEGER,DVN,getType(?));
        //addOperation(&dvnArrStr,"dvnArrStr",ARRAY, STR,DVN,getType(?));
        //addOperation(&dvnArrDec,"dvnArrDec",ARRAY, DECIMAL,DVN,getType(?));
        //addOperation(&dvnArrArr,"dvnArrArr",ARRAY, ARRAY,DVN,getType(?));

		addOperation(&powIntInt,"powIntInt",INTEGER, INTEGER,PWR,getType(INTEGER));


    // LIST INT OPERATIONS
    for (int i = 0; i < CANT_TYPES ; i++){
      addOperation(&addListAny,"addListAny",LIST, i,ADD,getType(LIST));
      addOperation(&subListAny,"subListAny",LIST, i,SUB,getType(LIST));
      addOperation(&multListAny,"multListAny",LIST, i,MUL,getType(LIST));
      addOperation(&divListAny,"divListAny",LIST, i,DVN,getType(LIST));
      addOperation(&addAnyList,"addAnyList",i, LIST,ADD,getType(LIST));
      addOperation(&subAnyList,"subAnyList", i, LIST,SUB,getType(LIST));
      addOperation(&multAnyList,"multAnyList", i, LIST,MUL,getType(LIST));
      addOperation(&divAnyList,"divAnyList", i, LIST,DVN,getType(LIST));
    }

		for (int i = 0 ; i < CANT_TYPES ; i++){
			for (int j = 0 ; j < CANT_TYPES; j++){
        if ( i != j ){
          addOperation(&differentType,"differentType", i, j, EQL ,getType(INTEGER));
          addOperation(&differentType,"differentType", i, j, LTS ,getType(INTEGER));
          addOperation(&differentType,"differentType", i, j, LES ,getType(INTEGER));
          addOperation(&differentType,"differentType", i, j, GTS ,getType(INTEGER));
          addOperation(&differentType,"differentType", i, j, GES ,getType(INTEGER));
        }
			}
		}
    // LIST AND LIST
    addOperation(&addListList,"addListList",LIST, LIST,ADD,getType(LIST));
    addOperation(&subListList,"subListList",LIST, LIST,SUB,getType(LIST));
    addOperation(&divListList,"divListList",LIST, LIST,DVN,getType(LIST));
    addOperation(&multListList,"multListList",LIST, LIST,MUL,getType(LIST));
    // EQUALS
    addOperation(&compareInt,"compareInt",INTEGER, INTEGER,EQL,getType(INTEGER));
    addOperation(&compareDecimal,"compareDecimal",DECIMAL, DECIMAL,EQL,getType(INTEGER));
    addOperation(&compareString,"compareString",STR, STR, EQL,getType(INTEGER));
    addOperation(&compareList,"compareList",LIST, LIST,EQL,getType(INTEGER));
    // LESS THAN
    addOperation(&ltInt,"ltInt",INTEGER, INTEGER,LTS,getType(INTEGER));
    addOperation(&ltDecimal,"ltDecimal",DECIMAL, DECIMAL,LTS,getType(INTEGER));
    addOperation(&ltString,"ltString",STR, STR, LTS,getType(INTEGER));
    addOperation(&ltList,"ltList",LIST, LIST,LTS,getType(INTEGER));
    // GREATER THAN
    addOperation(&gtInt,"gtInt",INTEGER, INTEGER,GTS,getType(INTEGER));
    addOperation(&gtDecimal,"gtDecimal",DECIMAL, DECIMAL,GTS,getType(INTEGER));
    addOperation(&gtString,"gtString",STR, STR, GTS,getType(INTEGER));
    addOperation(&gtList,"gtList",LIST, LIST, GTS,getType(INTEGER));
    // LESS EQUALS
    addOperation(&leInt,"leInt",INTEGER, INTEGER, LES,getType(INTEGER));
    addOperation(&leDecimal,"leDecimal",DECIMAL, DECIMAL,LES,getType(INTEGER));
    addOperation(&leString,"leString",STR, STR, LES,getType(INTEGER));
    addOperation(&leList,"leList",LIST, LIST,LES,getType(INTEGER));
    // GREATER EQUALS
    addOperation(&geInt,"geInt",INTEGER, INTEGER,GES,getType(INTEGER));
    addOperation(&geDecimal,"geDecimal",DECIMAL, DECIMAL,GES,getType(INTEGER));
    addOperation(&geString,"geString",STR, STR, GES,getType(INTEGER));
    addOperation(&geList,"geList",LIST, LIST,GES,getType(INTEGER));
}