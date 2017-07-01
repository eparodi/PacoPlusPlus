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

_object
newListFromList(List l);

void
addList(List l, _object o);

void
printList(List l);

_object
addListAny(_object o1, _object o2);
_object
subListAny(_object o1, _object o2);
_object
multListAny(_object o1, _object o2);
_object
divListAny(_object o1, _object o2);
_object
addAnyList(_object o1, _object o2);
_object
subAnyList(_object o1, _object o2);
_object
multAnyList(_object o1, _object o2);
_object
divAnyList(_object o1, _object o2);
_object
addListList(_object o1, _object o2);
_object
subListList(_object o1, _object o2);
_object
multListList(_object o1, _object o2);
_object
divListList(_object o1, _object o2);
#endif
