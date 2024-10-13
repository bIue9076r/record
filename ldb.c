#ifndef LDBT_C
#define LDBT_C
#include "ldb.h"
#include "str.h"

void print_header(header* h){
	printf("h = {\n");
	printf("\tmagic = %d;\n",h->magic);
	printf("\tversion = %d;\n",h->version);
	printf("\tsize = %lld;\n",h->size);
	printf("\tlookup[255];\n");
	printf("};\n");
}

void print_node(node* n){
	printf("n = {\n");
	printf("\tback = %lld;\n",n->back);
	printf("\tnext = %lld;\n",n->next);
	printf("\tindex = %s;\n",n->index);
	printf("\tvalue[255];\n");
	printf("\tfirst = %d;\n",n->first);
	printf("\ttaken = %d;\n",n->taken);
	printf("\tmoveable = %d;\n",n->moveable);
	printf("\tmissing = %d;\n",n->missing);
	printf("\tcondition = %d;\n",n->condition);
	printf("};\n");
}

node new_node(char in[INDEX_MAX], char v[VALUE_MAX]){
	node r;
	r.back = (offset_t)0;
	r.next = (offset_t)0;
	r.first = 0;
	r.taken = 0;
	r.moveable = 0;
	r.missing = 0;
	r.condition = EXCELENT;
	for(int i = 0; i < INDEX_MAX; i++){
		r.index[i] = in[i];
	}
	
	for(int i = 0; i < VALUE_MAX; i++){
		r.value[i] = v[i];
	}
	
	return r;
}

header new_header(){
	header r;
	r.magic = MAGIC;
	r.version = VERSION;
	r.size = HEADERSIZE;
	for (int i = 0; i < LOOKUP_MAX; i++){
		r.lookup[i] = 0;
	}
	return r;
}

boolean_t db_exists(char* path){
	FILE* dbfile = fopen(path, "rb");
	if(dbfile != NULL){
		header head;
		fread(&head, HEADERSIZE, 1, dbfile);
		if(head.magic == MAGIC){
			fclose(dbfile);
			return 1;
		}
		fclose(dbfile);
	}
	
	return 0;
}

boolean_t new_db(char* path){
	if(path == NULL){
		// bath path
		return 1;
	}
	
	if(db_exists(path)){
		// file exists
		return 1;
	}
	
	FILE* dbfile = fopen(path, "wb");
	
	if(dbfile == NULL){
		// file not opened
		return 1;
	}
	
	header head = new_header();
	fwrite(&head, HEADERSIZE, 1, dbfile);
	fclose(dbfile);
	return 0;
}

return_header read_db_head(char* path){
	if(path == NULL){
		// bath path
		return (return_header){.error=1};
	}
	
	if(!db_exists(path)){
		// file does not exist
		return (return_header){.error=1};
	}
	
	FILE* dbfile = fopen(path, "rb");
	
	if(dbfile == NULL){
		// file not opened
		return (return_header){.error=1};
	}
	
	header head;
	fread(&head, HEADERSIZE, 1, dbfile);
	fclose(dbfile);
	return (return_header){.error=0, .header = head};
}

boolean_t db_entry_exists(char* path, char in[INDEX_MAX]){
	FILE* dbfile = fopen(path, "rb");
	if(dbfile != NULL){
		header head;
		fread(&head,HEADERSIZE,1,dbfile);
		
		if(head.lookup[in[0]] == 0){
			fclose(dbfile);
			return 0;
		}
		
		node n;
		fseek(dbfile,head.lookup[in[0]],SEEK_SET);
		fread(&n,NODESIZE,1,dbfile);
		
		if(strequ(n.index,in) == 0){
			fclose(dbfile);
			return 1;
		}
		
		for(int i = 1; n.next != 0; i++){
			fseek(dbfile,n.next,SEEK_SET);
			fread(&n,NODESIZE,1,dbfile);
			
			if(strequ(n.index,in) == 0){
				fclose(dbfile);
				return 1;
			}
		}
		
		fclose(dbfile);
	}
	
	return 0;
}

boolean_t set_entry(char* path, char in[INDEX_MAX], char v[VALUE_MAX]){
	if(path == NULL){
		// bath path
		return 1;
	}
	
	if(!db_exists(path)){
		// file does not exist
		return 1;
	}
	
	FILE* dbfile = fopen(path, "rb+");
	
	if(dbfile == NULL){
		// file not opened
		return 1;
	}
	
	header head;
	fread(&head, HEADERSIZE, 1, dbfile);
	
	offset_t offset = head.lookup[in[0]];
	if(offset == 0){
		// if no offset
		offset = head.lookup[in[0]] = head.size;
		
		// node
		node n = new_node(in,v);
		n.back = 0;//offset;
		n.first = 1;
		
		fseek(dbfile, offset, SEEK_SET);
		fwrite(&n, NODESIZE, 1, dbfile);
		head.size = head.size + NODESIZE;
		fseek(dbfile, 0, SEEK_SET);
		fwrite(&head, HEADERSIZE, 1, dbfile);
	}else{
		// if offset
		if(db_entry_exists(path,in)){
			// node
			node n;
			node update = new_node(in,v);
			
			fseek(dbfile, offset, SEEK_SET);
			fread(&n,NODESIZE,1,dbfile);
			if(strequ(n.index,in) == 0){
				update.back = n.back;
				update.next = n.next;
				update.first = n.first;
				fseek(dbfile, offset, SEEK_SET);
				fwrite(&update,NODESIZE,1,dbfile);
				
				head.size = head.size + NODESIZE;
				fseek(dbfile, 0, SEEK_SET);
				fwrite(&head, HEADERSIZE, 1, dbfile);
				fclose(dbfile);
				return 0;
			}
			
			for(int i = 0; n.next != 0; i++){
				offset = n.next;
				fseek(dbfile, offset, SEEK_SET);
				fread(&n,NODESIZE,1,dbfile);
				if(strequ(n.index,in) == 0){
					update.back = n.back;
					update.next = n.next;
					update.first = n.first;
					fseek(dbfile, offset, SEEK_SET);
					fwrite(&update,NODESIZE,1,dbfile);
					
					head.size = head.size + NODESIZE;
					fseek(dbfile, 0, SEEK_SET);
					fwrite(&head, HEADERSIZE, 1, dbfile);
					fclose(dbfile);
					return 0;
				}
			}
		}else{
			// node
			node n;
			node nw = new_node(in,v);
			
			fseek(dbfile, offset, SEEK_SET);
			fread(&n,NODESIZE,1,dbfile);
			
			while(n.next != 0){
				offset = n.next;
				fseek(dbfile, n.next, SEEK_SET);
				fread(&n,NODESIZE,1,dbfile);
			}
			
			n.next = head.size;
			nw.back = offset;
			fseek(dbfile, offset, SEEK_SET);
			fwrite(&n,NODESIZE,1,dbfile);
			fseek(dbfile, head.size, SEEK_SET);
			fwrite(&nw, NODESIZE, 1, dbfile);
			
			head.size = head.size + NODESIZE;
			fseek(dbfile, 0, SEEK_SET);
			fwrite(&head, HEADERSIZE, 1, dbfile);
		}
	}
	
	fclose(dbfile);
	return 0;
}

return_node get_entry(char* path, char in[INDEX_MAX], char v[VALUE_MAX]){
	if(path == NULL){
		// bath path
		return (return_node){.error=1};
	}
	
	if(!db_exists(path)){
		// file does not exist
		return (return_node){.error=1};
	}
	
	FILE* dbfile = fopen(path, "rb");
	
	if(dbfile == NULL){
		// file not opened
		return (return_node){.error=1};
	}
	
	header head;
	fread(&head, HEADERSIZE, 1, dbfile);
	
	offset_t offset = head.lookup[in[0]];
	if(offset == 0){
		// no offset
		fclose(dbfile);
		return (return_node){.error=1};
	}else{
		// if offset
		if(db_entry_exists(path,in)){
			// node
			node n;
			
			fseek(dbfile, offset, SEEK_SET);
			fread(&n,NODESIZE,1,dbfile);
			if(strequ(n.index,in) == 0){
				fclose(dbfile);
				return (return_node){.error=0, .node = n};
			}
			
			for(int i = 0; n.next != 0; i++){
				offset = n.next;
				fseek(dbfile, offset, SEEK_SET);
				fread(&n,NODESIZE,1,dbfile);
				if(strequ(n.index,in) == 0){
					fclose(dbfile);
					return (return_node){.error=0, .node = n};
				}
			}
		}else{
			// no node
			fclose(dbfile);
			return (return_node){.error=1};
		}
	}
	
	// What
	fclose(dbfile);
	return (return_node){.error=1};
}
#endif
