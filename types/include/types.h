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

typedef struct Type{
  uint64_t id;
  char * name;
  size_t size;
  ObjectT obj;
}Type;

typedef Type * TypeT;

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
#endif