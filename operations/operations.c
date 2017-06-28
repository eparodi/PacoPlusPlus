#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "include/operations.h"


_object createInt(int num){
	_object o = malloc(sizeof(Object));
	if (!o){
		return NULL;
	}
	o->type = getType(INTEGER);
	o->cont.num = num;
	return o;
}

_object createDecimal(float num){
	_object o = malloc(sizeof(Object));
	if (!o){
		return NULL;
	}
	o->type = getType(DECIMAL);
	o->cont.fl = num;
	return o;
}

_object createString(char* str){
	_object o = malloc(sizeof(Object));
	if (!o){
		return NULL;
	}
	o->type = getType(STR);
	o->cont.str = malloc(strlen(str)+1);
	strcpy(o->cont.str, str);
	return o;
}

_object powIntInt(_object o1, _object o2) {
	return createInt((int)pow(o1->cont.num, o2->cont.num));
}


// ------------------------ AUX FUNCTIONS ------------------------------

int digitCount(int n) {
	int count = 0;
	while(n != 0)
	{
        n /= 10;
        ++count;
    }
    return count;
}

void invertStr(char * str) {
	int i = 0, j = strlen(str)-1;
	while(i < j) {
		char auxc = str[i];
		str[i] = str[j];
		str[j] = auxc;
		i++;j--;
	}
}

/*
 * Assigns to dest a pointer to a string with n times str concatenated.
 * The functions assumes that dest have enough space to hold n times str and '\0' and is initially filled with 0.
 */
void multiplyString(char* str, int n, char* dest) {
	while(n-- > 0) {
		strcat(dest, str);
	}
}

char* itoa(int n){
	char* intStr = calloc(1, digitCount(n) + 1);
	sprintf(intStr, "%d", n);
	return intStr;
}