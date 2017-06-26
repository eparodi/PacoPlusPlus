#ifndef OBJECTS_H
#define OBJECTS_H

#include "types.h"

typedef struct Type * TypeT;

typedef struct Object{
  void * data;
  TypeT type;
}Object;

typedef Object * ObjectT;

ObjectT
createObject(void * data, TypeT type);

#endif