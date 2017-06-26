#include "include/integer.h"
#include <stdlib.h>
#include "include/types.h"

//------------------------------------------------------------------------------
//                                 MACROS.
//------------------------------------------------------------------------------

/*
 * Macro for creating a new Integer type.
 */
#define NEW_INT() ( malloc(sizeof(int)) )

/*
 * Macro for operations. Op is the operator to use ( + | - | * | / ).
 */
#define OPERATION(op) ({                         \
                        Integer ret = NEW_INT(); \
                        if (!ret){               \
                          return NULL;           \
                        }                        \
                        *ret = *i1 op *i2;       \
                        return ret;              \
                      })

//------------------------------------------------------------------------------
//                         Function implementation.
//------------------------------------------------------------------------------

TypeT
createIntegerType(){
  return createType("Integer", sizeof(int));
}

Integer
newInteger(int number){
  return (Integer) NEW_INT(); 
}

Integer
intPlusInt(Integer i1, Integer i2){
  OPERATION(+);
}

Integer
intMinusInt(Integer i1, Integer i2){
  OPERATION(-);
}

Integer
intByInt(Integer i1, Integer i2){
  OPERATION(*);
}

Integer
intDividedInt(Integer i1, Integer i2){
  OPERATION(/);
}