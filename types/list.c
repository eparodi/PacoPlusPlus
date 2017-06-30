#include "include/list.h"

_object
operationOneByOne(List l, _object o, OpValue opV, ListOrder order);

_object
newList(){
  _object o = malloc(sizeof(Object));
  o->type = getType(LIST);
  List l = malloc(sizeof(ListC));
  l->first = NULL;
  l->size = 0;
  o->cont.obj = l;
  return o;
}


_object
newListFromList(List l){
  _object o = malloc(sizeof(Object));
  o->type = getType(LIST);
  o->cont.obj = l;
  return o;
}

void
addList(List l, _object o){
  Node * n = malloc(sizeof(Node));
  n->next = l->first;
  l->size++;
  n->obj = o;
  l->first = n;
  return;
}

_object
operationOneByOne(List l, _object o, OpValue opV, ListOrder order){
  Node * current = l->first;
  Node * current_new = NULL;
  _object lNew = newList();
  while(current){
    Node * newNode = malloc(sizeof(Node));
    OperationT op = getOperation(opV, current->obj->type, o->type);
    if (order == FIRST_LIST){
      newNode->obj = op->func(current->obj, o);
    }else{
      op->func(o, current->obj);
    }
    ((List) lNew->cont.obj)->size++;
    if (!current_new)
      ((List) lNew->cont.obj)->first = newNode;
    else{
      current->next = newNode;
      current = newNode;
    }
  }
  return lNew;
}

_object
addListAny(_object o1, _object o2){
  return operationOneByOne((List) o1->cont.obj, o2, ADD, FIRST_LIST);
}

_object
subListAny(_object o1, _object o2){
  return operationOneByOne((List) o1->cont.obj, o2, SUB, FIRST_LIST);
}

_object
multListAny(_object o1, _object o2){
  return operationOneByOne((List) o1->cont.obj, o2, MUL, FIRST_LIST);
}

_object
divListAny(_object o1, _object o2){
  return operationOneByOne((List) o1->cont.obj, o2, DVN, FIRST_LIST);
}

_object
addAnyList(_object o1, _object o2){
  return operationOneByOne((List) o2->cont.obj, o1, ADD, SECOND_LIST);
}

_object
subAnyList(_object o1, _object o2){
  return operationOneByOne((List) o2->cont.obj, o1, SUB, SECOND_LIST);
}

_object
multAnyList(_object o1, _object o2){
  return operationOneByOne((List) o2->cont.obj, o1, MUL, SECOND_LIST);
}

_object
divAnyList(_object o1, _object o2){
  return operationOneByOne((List) o2->cont.obj, o1, DVN, SECOND_LIST);
}

void
printList(List l) {
  printf("[ ");
  Node * current = l->first;
  while(current){
    printObject(current->obj);
    if(current->next)
      printf(", ");
    current = current->next;
  }
  printf(" ]");
}
