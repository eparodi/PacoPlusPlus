#ifndef TYPES_H
#define TYPES_H

#include "objects.h"
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

typedef struct Object * ObjectT;

/*
 * This is the structure of a Type. It has an id, the number that represents the
 * type, a name, the size of the type.
 */
typedef struct Type{
  uint64_t id;
  char * name;
  size_t size;
  ObjectT obj;
}Type;

/*
 * Pointer to the Type Structure.
 */
typedef Type * TypeT;

enum OpValue{
  ADD,
  SUB,
  MUL,
  DIV,
};

typedef struct Operation{
  void * func;
  TypeT return_type;
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
createType(char * name, size_t size);

int
addOperation(void * function, const char * name, TypeT first_op, \
            TypeT second_op, TypeT return_type);

#endif