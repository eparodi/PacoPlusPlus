#include "include/list.h"

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

void
printList(List l) {
  printf("[ ");
  Node * current = l->first;
  while(current){
    printObject(current->obj);
    if(current->next)
      printf(", ");
  }
  printf(" ]");
}
