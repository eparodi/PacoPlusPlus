#include "hashtable.h"

/* 
 * When the quotient between the size and the capacity is bigger than this
 * number, the HashTable rehashes.
 */
#define LOAD_FACTOR 0.7

/*
 * Rehash the HashTable, the elements inside are reordered to improve the
 * performance, when the quotient between the size and the capacity is bigger
 * than the load factor.
 * Returns HT_ERROR if there was an error.
 */
static int
rehash(hashTableT hash_table);

/*
 * Creates an pointer to a HashTableElem, that contains the key and the value.
 */
static hashTableElem *
createElement(void * key, void * value, int hash);

//------------------------------------------------------------------------------
//                         Function implementation.
//------------------------------------------------------------------------------

hashTableT
createHashTable(size_t key_size, size_t value_size, \
                hashFunction hash, size_t capacity, equalsFunction equals){
  
  hashTableT hash_table = malloc(sizeof(hashTable));
  if (!hash_table){
    return NULL;
  }
  
  hashTableElem ** buckets = calloc(capacity, sizeof(hashTableElem*));

  if (!buckets){
    free(hash_table);
    return NULL;
  }
  
  hash_table->buckets = buckets;
  hash_table->capacity = capacity;
  hash_table->hash = hash;
  hash_table->equals = equals;
  hash_table->key_size = key_size;
  hash_table->value_size = value_size;
  hash_table->size = 0;

  return hash_table;
}

void 
deleteHashTable(hashTableT hash_table){
  for (int i = 0; i < hash_table->capacity; i++){
    hashTableElem * current = hash_table->buckets[i];
    if (current){
      hashTableElem * delete_node = current;
      current = current->next;
      free(delete_node);
    }
  }
  free(hash_table->buckets);
  free(hash_table);
}

int
addElementHT(hashTableT hash_table, void * key, void * value){
  int hash = hash_table->hash(key);
  int bucket = hash % hash_table->capacity;
  hashTableElem * current = hash_table->buckets[bucket];
  if (!current){
    hash_table->buckets[bucket] = createElement(key, value, hash);
    if (hash_table->buckets[bucket]){
      hash_table->buckets[bucket]->next = NULL;
      return HT_OK;
    }
    return HT_ERROR;
  }
  while(current){
    if (hash_table->equals(key, current->key)){
      current->value = value;
      return HT_OK;
    }
    if (!current->next){
      current->next = createElement(key, value, hash);
      if (current->next){
        hash_table->size++;
        current->next->next = NULL;
        if (hash_table->capacity * LOAD_FACTOR < hash_table->size){
          rehash(hash_table);
        }
        return HT_OK;
      }
      return HT_ERROR;
    }
    current = current->next;
  }
}

int
deleteElementHT(hashTableT hash_table, void * key){
  int hash = hash_table->hash(key);
  int bucket = hash % hash_table->capacity;
  hashTableElem * current = hash_table->buckets[bucket];
  if(!current){
    return HT_ERROR;
  }
  if(hash_table->equals(key, current->key)){
    hash_table->buckets[bucket] = current->next;
    free(current);
    return HT_OK;
  }
  
  hashTableElem * previous = current;
  current = current->next;
  while(current){
    if(hash_table->equals(key, current->key)){
      previous->next = current->next;
      free(current);
      hash_table->size--;
      return HT_OK;
    }
    previous = current;
    current = current->next;
  }
  return HT_ERROR;
}

void *
getElementHT(hashTableT hash_table, void * key){
  int hash = hash_table->hash(key);
  int bucket = hash % hash_table->capacity;
  hashTableElem * current = hash_table->buckets[bucket];
  while(current){
    if(hash_table->equals(key, current->key)){
      return current->value;
    }
    current = current->next;
  }
  return NULL;
}

//------------------------------------------------------------------------------
//                           Auxiliary functions.
//------------------------------------------------------------------------------

static int
rehash(hashTableT hash_table){
  size_t old_capacity = hash_table->capacity;
  size_t capacity = old_capacity * 2;
  hash_table->capacity = capacity;
  hashTableElem ** new_buckets = \
      calloc(capacity, sizeof(hashTableElem*));
  
  if (!new_buckets){
    hash_table->capacity = old_capacity;
    return HT_ERROR;
  }

  for (int i = 0; i < old_capacity; i++){
    hashTableElem * current = hash_table->buckets[i];
    hashTableElem * next_elem;
    while (current){
      size_t bucket = current->hash % capacity;
      hashTableElem * bucket_elem = new_buckets[bucket];
      next_elem = current->next;
      if (!bucket_elem){
        new_buckets[bucket] = current;
        current->next = NULL;
      }else{
        current->next = new_buckets[bucket];
        new_buckets[bucket] = current;
      }
      current = next_elem;
    }
  }
  
  free(hash_table->buckets);
  hash_table->buckets = new_buckets;
  return HT_OK;
}

static hashTableElem *
createElement(void * key, void * value, int hash){
  hashTableElem * new_elem = malloc(sizeof(hashTableElem));
  if (!new_elem){
    return NULL;
  }
  
  new_elem->key = key;
  new_elem->value = value;
  new_elem->hash = hash;
    
  return new_elem;
}