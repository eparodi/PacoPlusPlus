#ifndef INTEGER_H
#define INTEGER_H

#include "types.h"

/*
 * Integer Type.
 */
typedef int * Integer;

/*
 * Adds the Integer Type to the current types.
 */
TypeT
createIntegerType();

/*
 * Returns the addition of 2 integers.
 */
Integer
intPlusInt(Integer i1, Integer i2);

/*
 * Returns the substraction of 2 integers.
 */
Integer
intMinusInt(Integer i1, Integer i2);

/*
 * Returns the multiplication of 2 integers.
 */
Integer
intByInt(Integer i1, Integer i2);

/*
 * Returns the division quotient.
 */
Integer
intDividedInt(Integer i1, Integer i2);

#endif