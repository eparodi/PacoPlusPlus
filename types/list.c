#include "include/list.h"

_object
operationOneByOne(List l, _object o, OpValue opV, ListOrder order);

_object
listAndListOperation(_object li1, _object li2, OpValue oper);

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
    Node * newNode = calloc(1,sizeof(Node));
    OperationT op = getOperation(opV, current->obj->type, o->type);
    if (order == FIRST_LIST){
      newNode->obj = op->func(current->obj, o);
    }else{
      op->func(o, current->obj);
    }
    ((List) lNew->cont.obj)->size++;
    if (!current_new){
      ((List) lNew->cont.obj)->first = newNode;
      current_new = newNode;
    }else{
      current_new->next = newNode;
      current_new = newNode;
    }
    current = current->next;
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

_object
listAndListOperation(_object li1, _object li2, OpValue oper){
  List l1 = li1->cont.obj;
  List l2 = li2->cont.obj;
  Node * current1 = l1->first;
  Node * current2 = l2->first;
  Node * current_new = NULL;
  _object lNew = newList();
  while(current1 && current2){
    Node * newNode = calloc(1,sizeof(Node));
    OperationT op = getOperation(oper, current1->obj->type, current2->obj->type);
    _object ret = op->func(current1->obj,current2->obj);
    ((List) lNew->cont.obj)->size++;
    newNode->obj = ret;
    if (!current_new){
      ((List) lNew->cont.obj)->first = newNode;
      current_new = newNode;
    }else{
      current_new->next = newNode;
      current_new = newNode;
    }
    current1 = current1->next;
    current2 = current2->next;
  }
  return lNew;
}

_object
addListList(_object o1, _object o2){
  return listAndListOperation(o1, o2, ADD);
}

_object
subListList(_object o1, _object o2){
  return listAndListOperation(o1, o2, SUB);
}

_object
multListList(_object o1, _object o2){
  return listAndListOperation(o1, o2, MUL);
}

_object
divListList(_object o1, _object o2){
  return listAndListOperation(o1, o2, DVN);
}