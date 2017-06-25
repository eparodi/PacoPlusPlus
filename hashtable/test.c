#include "hashtable.h"
#include <stdio.h>
#include <time.h>

static unsigned int str_hash(char* key){
	unsigned int h = 5381;
	while(*(key++))
		h = ((h << 5) + h) + (*key);
	return h;
}

static unsigned int str_eql(const char * s1, const char * s2){
  int i = 0;
  while(s1[i] && s1[i] == s2[i]){
    i++;
  }
  return s1[i] == s2[i];
}

char *
random_string(){
  int size = rand() % 10 + 5;
  char * str = malloc(sizeof(char) * size);
  for ( int i = 0 ; i < size - 1 ; i++ ){
    char ascii = rand() % 26 + 65;
    str[i] = ascii;
  }
  str[size-1] = 0;
  return str;
}

int *
random_int(){
  int * my_int = malloc(sizeof(int));
  *my_int = rand();
  return my_int;
}

int
main(void){
  srand(time(NULL));
  hashTableT ht = createHashTable(sizeof(char*), sizeof(int), \
            (hashFunction)&str_hash, 4, (equalsFunction) &str_eql);
  char * str;
  for (int i = 0 ; i < 100000000; i++){
    str = random_string();
    if (addElementHT(ht, str, random_int()) != HT_ERROR)
      ; // printf("%s was added to the HashTable.\n",str);
    else
      printf("%s wasn't added to the HashTable.\n",str);
  }
  if (deleteElementHT(ht,str) != HT_ERROR)
    printf("%s was deleted\n", str);
  else
    printf("%s wasn't deleted.\n", str);
  char * trucho = "HOLIS";
  
  if (deleteElementHT(ht,trucho) != HT_ERROR)
    printf("%s was deleted\n", trucho);
  else
    printf("%s wasn't deleted.\n", trucho);
    
  return 0;
}