#ifndef OBJECTS_H
#define OBJECTS_H

#include "types.h"

typedef struct Type * TypeT;

typedef struct Object{
  void * data;
  TypeT type;
}Object;

typedef Object * ObjectT;

typedef struct Operation{
  void * func;
  TypeT return_type;
}Operation;

typedef Operation * OperationT;

ObjectT
createObject(void * data, TypeT type);

#endif