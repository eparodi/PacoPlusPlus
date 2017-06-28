#ifndef TYPES_H
#define TYPES_H

#include <stddef.h>
#include <stdint.h>

/*
 * A value that is returned if an error ocurrs.
 */
#define TYPE_OK   1

/*
 * A value that is returned if everything is fine.
 */
#define TYPE_ERR -1

/*
 * The Type type name.
 */
#define TYPE_NAME "Type"

/*
 * This is the structure of a Type. It has an id, the number that represents the
 * type, a name, the size of the type.
 */
typedef struct Type{
  uint64_t id;
  char * name;
}Type;

/*
 * Pointer to the Type Structure.
 */
typedef Type * TypeT;

typedef enum OpValue{
  ADD,
  SUB,
  MUL,
  DVN,
  PWR,
  CANT_OPERATIONS // ALWAYS AT THE END. Use this instead of sizeof(OpValues), it does not work.
}OpValue;

typedef enum TypesID{
	TYPE,
	INTEGER,
	DECIMAL,
	STR
}TypesID;

typedef struct Operation{
  void * (*func)(void *, void *);
  char * func_name;
}Operation;

typedef Operation * OperationT;

/*
 * Creates the table that contains all the types. This function must be
 * called after starting the compiler.
 */
int
startTypes();

/*
 * Creates a new type.
 */
TypeT
createType(char * name);

int
buildOpTable();

int
addOperation(void * function, const char * name, TypesID first_op, \
            TypesID second_op, OpValue operator);

TypeT
getType(TypesID id);

OperationT
getOperation(OpValue op, TypeT type1, TypeT type2);

#endif
