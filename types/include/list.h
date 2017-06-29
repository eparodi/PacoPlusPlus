#ifndef LIST_H
#define LIST_H

#include "types.h"
#include <stdlib.h>

typedef enum OpValue OpValue;
typedef struct Object Object;
typedef Object * _object;

typedef struct Node Node;

typedef struct Node{
  Node * next;
  _object obj;
} Node;

typedef struct ListC{
  Node * first;
  size_t size;
}ListC;

typedef enum ListOrder{
  FIRST_LIST,
  SECOND_LIST
} ListOrder;

typedef ListC * List;

_object
newList();

void
addList(List l, _object o);

_object
operationOneByOne(List l, _object o, OpValue opV, ListOrder order);

void
printList(List l);

#endif
