#include "include/objects.h"
#include <stdlib.h>

//------------------------------------------------------------------------------
//                         Function implementation.
//------------------------------------------------------------------------------

ObjectT
createObject(void * data, TypeT type){
  ObjectT obj = malloc(sizeof(Object));
  if (!obj){
    return NULL;
  }
  
  obj->data = data;
  obj->type = type;
  
  return obj;
}