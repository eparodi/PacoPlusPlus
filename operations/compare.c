#include "include/compare.h"
#include <string.h>

_object
checkList(_object li1, _object li2, OpValue oper);

_object
differentType(_object o1, _object o2){
  return FALSE;
}

_object
compareInt(_object o1, _object o2){
  return createInt(o1->cont.num == o2->cont.num);
}

_object
compareDecimal(_object o1, _object o2){
  return createInt(o1->cont.fl == o2->cont.fl);
}

_object
compareString(_object o1, _object o2){
  return createInt(strcmp(o1->cont.str, o2->cont.str)==0);
}

_object
compareList(_object o1, _object o2){
  return checkList(o1, o2, EQL);
}

_object
leInt(_object o1, _object o2){
  return createInt(o1->cont.num <= o2->cont.num);
}

_object
leDecimal(_object o1, _object o2){
  return createInt(o1->cont.fl <= o2->cont.fl);
}

_object
leString(_object o1, _object o2){
  return createInt(strcmp(o1->cont.str, o2->cont.str)<=0);
}

_object
leList(_object o1, _object o2){
  return checkList(o1, o2, LES);
}

_object
ltInt(_object o1, _object o2){
  return createInt(o1->cont.num < o2->cont.num);
}

_object
ltDecimal(_object o1, _object o2){
  return createInt(o1->cont.fl < o2->cont.fl);
}

_object
ltString(_object o1, _object o2){
  return createInt(strcmp(o1->cont.str, o2->cont.str)<0);
}

_object
ltList(_object o1, _object o2){
  return checkList(o1, o2, LTS);
}

_object
geInt(_object o1, _object o2){
  return createInt(o1->cont.num >= o2->cont.num);
}

_object
geDecimal(_object o1, _object o2){
  return createInt(o1->cont.fl >= o2->cont.fl);
}

_object
geString(_object o1, _object o2){
  return createInt(strcmp(o1->cont.str, o2->cont.str)>=0);
}

_object
geList(_object o1, _object o2){
  return checkList(o1, o2, GES);
}

_object
gtInt(_object o1, _object o2){
  return createInt(o1->cont.num > o2->cont.num);
}

_object
gtDecimal(_object o1, _object o2){
  return createInt(o1->cont.fl > o2->cont.fl);
}

_object
gtString(_object o1, _object o2){
  return createInt(strcmp(o1->cont.str, o2->cont.str)>0);
}

_object
gtList(_object o1, _object o2){
  return checkList(o1, o2, GTS);
}

_object
checkList(_object li1, _object li2, OpValue oper){
  List l1 = li1->cont.obj;
  List l2 = li2->cont.obj;
  if ( l1->size != l2->size ){
    return FALSE;
  }
  Node * current1 = l1->first;
  Node * current2 = l2->first;
  while(current1){
    OperationT op = getOperation(oper, current1->obj->type, current2->obj->type);
    _object ret = op->func(current1->obj,current2->obj);
    if (!ret->cont.num){
      return ret;
    }
    current1 = current1->next;
    current2 = current2->next;
  }
  return TRUE;
}
