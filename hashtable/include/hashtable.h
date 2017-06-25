#ifndef HASHTABLE_H
#define HASHTABLE_H

#include <stddef.h>

/*
 * A value that is returned if an error ocurrs.
 */
#define HT_ERROR -1

/*
 * A value that is returned if everything is fine.
 */
#define HT_OK 1

/*
 * This is a function pointer that represents the hash function. This if
 * for the sake of the understanding. 
 */
typedef int (*hashFunction)(void *);

/*
 * This is a function pointer that represents the equals function. This function
 * returns 0 (zero) if both keys are not equals, otherwise, any number is fine.
 */
typedef int (*equalsFunction)(void *, void *);

/*
 * A HashTable element. It contains a key, a value and a pointer to the next
 * element.
 */
typedef struct hashTableElem{
  void * key;
  void * value;
  struct hashTableElem * next;
  int hash;
} hashTableElem;

/*
 * The HashTable concret data type.
 */
typedef struct hashTable{
  size_t key_size;
  size_t value_size;
  hashFunction hash;
  equalsFunction equals;
  size_t size;
  size_t capacity;
  hashTableElem ** buckets;
} hashTable;

/* 
 * Pointer to the HashTable abstract data type.
 */
typedef hashTable * hashTableT;

/*
 * Returns a new HashTable.
 */
hashTableT
createHashTable(size_t key_size, size_t value_size, \
                hashFunction hash, size_t capacity, equalsFunction equals);

/*
 * Deletes the HashTable.
 */
void 
deleteHashTable(hashTableT hash_table);

/*
 * Adds the pair key and value to the HashTable.
 */
int
addElementHT(hashTableT hash_table, void * key, void * value);

/*
 * Deletes the key and its value from the HashTable.
 */
int
deleteElementHT(hashTableT hash_table, void * key);

/*
 * Returns the element associated to the key.
 */
void *
getElementHT(hashTableT hash_table, void * key);

#endif