#ifndef LDBT_H
#define LDBT_H
#include <stdio.h>

#define MAGIC 0x13311331
#define VERSION 0

#define LOOKUP_MAX 255
#define INDEX_MAX 16
#define VALUE_MAX 255

#define NODESIZE sizeof(node)
#define HEADERSIZE sizeof(header)
#define UINTSIZE sizeof(unsigned int)

typedef unsigned long long int offset_t;

typedef unsigned int boolean_t;

typedef enum {POOR, MODERATE, GOOD, GREAT, EXCELENT} condition_t;

typedef struct node_s {
	offset_t back;
	offset_t next;
	boolean_t first;
	char index[INDEX_MAX];
	char value[VALUE_MAX];
	boolean_t taken;
	boolean_t moveable;
	boolean_t missing;
	condition_t condition;
} node;

typedef struct return_node_s {
	boolean_t error;
	node node;
} return_node;

typedef struct return_nodes_s {
	boolean_t error;
	unsigned int size;
	node* nodes;
} return_nodes;

typedef struct header_s {
	unsigned int magic;
	unsigned int version;
	unsigned int flags;
	offset_t size;
	offset_t lookup[LOOKUP_MAX];
} header;

typedef struct return_header_s {
	boolean_t error;
	header header;
} return_header;


// Private

void print_header(header* h);
void print_node(node* n);
node new_node(char in[INDEX_MAX], char v[VALUE_MAX], boolean_t t, boolean_t mov, boolean_t mis, condition_t c);
header new_header();
return_header read_db_head(char* path);

// Public

boolean_t new_db(char* path);
boolean_t db_exists(char* path);
boolean_t db_entry_exists(char* path, char in[INDEX_MAX]);
boolean_t set_entry(char* path, char in[INDEX_MAX], char v[VALUE_MAX], boolean_t t, boolean_t mov, boolean_t mis, condition_t c);
return_node get_entry(char* path, char in[INDEX_MAX]);
return_nodes get_all(char* path);
#endif
