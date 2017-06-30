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