#include "include/types.h"
#include "../hashtable/include/hashtable.h"
#include <string.h>
#include <stdlib.h>

/*
 * This is a global variable that stores the id of the next element added to the
 * types table.
 */
static uint64_t type_id = 0;

/*
 * This HashTable contains the types created.
 */
static TypeT * types_table;

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
copyTypeName(const char * name);

void
freeFailOpTable();
//------------------------------------------------------------------------------
//                         Function implementation.
//------------------------------------------------------------------------------
int
startTypes(){
  types_table = malloc(sizeof(TypesID)/sizeof(int));
  if (!types_table){
    return TYPE_ERR;
  }

  type_type = createType(TYPE_NAME);
	createType("Integer");
	createType("Decimal");
	createType("String");
  createType("List");
  int check = buildOpTable();
  if (!type_type || check == TYPE_ERR){
    return TYPE_ERR;
  }
  return TYPE_OK;
}

TypeT
createType(char * name){
  int id = type_id++;
  TypeT type = malloc(sizeof(Type));
  name = copyTypeName(name);

  if (!type || !name){
    free(type);
    free(name);
    return NULL;
  }

  type->id = id;
  type->name = name;

  types_table[id] = type;
  return type;
}

TypeT
getType(TypesID id){
	return types_table[id];
}

OperationT
getOperation(OpValue op, TypeT type1, TypeT type2){
	return op_table[op][type1->id][type2->id];
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
			printf("\"%s\"", o->cont.str);
			break;
    case LIST:
      printList(o->cont.obj);
      break;
	}
}

//------------------------------------------------------------------------------
//                           Auxiliary functions.
//------------------------------------------------------------------------------

char *
copyTypeName(const char * name){
  int length = strlen(name) + 1;
  char * copy = malloc(length);
  if (!copy){
    return NULL;
  }
  return strcpy(copy, name);
}

int
buildOpTable(){
  int size = CANT_OPERATIONS;
  op_table = calloc(CANT_OPERATIONS, sizeof(void *));

  if (!op_table){
    return TYPE_ERR;
  }

  for (int i = 0; i < size ; i++){
    OperationT ** array = calloc(type_id, sizeof(void *));
    if (!array){
      freeFailOpTable();
      return TYPE_ERR;
    }
    op_table[i] = array;
    for (int j = 0; j < type_id; j++){
      array[j] = calloc(type_id, sizeof(void *));
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
  int size = CANT_OPERATIONS;
  for(int i = 0; i < size; i++ ){
    for(int j = 0; j < type_id; j++){
      free(op_table[i][j]);
    }
    free(op_table[i]);
  }
  free(op_table);
}

int
addOperation(void * function, const char * name, TypesID first_op, \
            TypesID second_op, OpValue operator, TypeT return_type){
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
  op->func_name = cp_name;
  op->return_type = return_type;

	op_table[operator][first_op][second_op] = op;
  return TYPE_OK;
}
