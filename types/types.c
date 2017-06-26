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
 * This table contains all the operations so the compiler can take them and 
 * execute them to improve the code or get the name of the functions to create
 * the C file. The first pointer contains a list of pointer in which every index 
 * is associated with an operator (OpValue enum). In this list every pointer
 * belongs to a type, and so the pointed list. This way, there are two types and 
 * the function associated with the operation corresponding both types can be
 * accessed.
 */
static OperationT *** op_table;

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

int
buildOpTable();

void 
freeFailOpTable();
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
  int check = buildOpTable();
  if (!type_type || check == TYPE_ERR){
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

int
buildOpTable(){
  int size = sizeof(enum)/sizeof(int);
  op_table = calloc(size);
  
  if (!op_table){
    return TYPE_ERR;
  }
  
  for (int i = 0; i < size ; i++){
    OperationT ** array = calloc(type_id);
    if (!array){
      freeFailOpTable();
      return TYPE_ERR;
    }
    op_table[i] = array;
    for (int j = 0; j < type_id; j++){
      array[j] = calloc(type_id);
      if (!array[j]){
        freeFailOpTable();
        return TYPE_ERR;
      }
    }
  }
  return TYPE_OK;
}

void 
freeFailOpTable() {
  int size = sizeof(enum)/sizeof(int);
  for(int i = 0; i < size; i++ ){
    for(int j = 0; j < type_id; j++){
      free(op_table[i][j]);
    }
    free(op_table[i]);
  }
  free(op_table);
}

int
addOperation(void * function, const char * name, TypeT first_op, \
            Type2 second_op, TypeT return_type){
  OperationT op = malloc(sizeof(Operation));
  if (!op){
    return TYPE_ERR;
  }
  char * cp_name = copyTypeName(name);
  if (!cp_name){
    free(op);
    return TYPE_ERR;
  }
  op->func = function;
  op->return_type = return_type;
  op->name = cp_name;
  
  return TYPE_OK;
}