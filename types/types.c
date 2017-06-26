#include "include/types.h"
#include "../hashtable/include/hashtable.h"
#include <string.h>
#include <stdlib.h>
#include "include/integer.h"

/*
 * This is a global variable that stores the id of the next element added to the
 * types table. 
 */
static uint64_t type_id = 0;

/*
 * This HashTable contains the types created.
 */
static hashTableT types_table;

/*
 * This is the Type type.
 */
static TypeT type_type;

/*
 * The hash function for the HashTable.
 */
int
hashType(int * value);

/*
 * The equals function for the HashTable.
 */
int
equalsType(int * v1, int * v2);

/*
 * This copy the name of the Type in the heap so there is no problem in the
 * stack with the type names.
 */
char *
copyTypeName(char * name);

//------------------------------------------------------------------------------
//                         Function implementation.
//------------------------------------------------------------------------------
int
startTypes(){
  types_table = createHashTable(sizeof(int*), sizeof(TypeT), \
        (hashFunction) &hashType, 25, (equalsFunction) &equalsType);
  if (!types_table){
    return TYPE_ERR;
  }
  
  type_type = createType(TYPE_NAME, sizeof(Type));
  if (!type_type){
    return TYPE_ERR;
  }
  return TYPE_OK;
}

TypeT
createType(char * name, size_t size){
  uint64_t * id = malloc(sizeof(uint64_t));
  if (!id){
    return NULL;
  }
  *id = type_id++;
  TypeT type = malloc(sizeof(Type));
  ObjectT obj = malloc(sizeof(Object));
  name = copyTypeName(name);
  
  if (!obj || !type || !name){
    free(id);
    free(obj);
    free(type);
    free(name);
    return NULL;
  }

  type->id = *id;
  type->name = name;
  type->size = size;
  type->obj = obj;
  
  obj->data = type;
  obj->type = type_type;

  int err = addElementHT(types_table, id, type);
  if (err == HT_ERROR){
    return NULL;
  }
  return type;
}

//------------------------------------------------------------------------------
//                           Auxiliary functions.
//------------------------------------------------------------------------------

int
hashType(int * value){
  return *value;
}

int
equalsType(int * v1, int * v2){
  return *v1 == *v2;
}

char *
copyTypeName(char * name){
  int length = strlen(name) + 1;
  char * copy = malloc(length);
  if (!copy){
    return NULL;
  }
  return strcpy(copy, name);
}