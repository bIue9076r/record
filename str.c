/* String functions */
#ifndef STR_C
#define STR_C

// Private

void snc(char* des, int l, char* src){
	for(int i = 0; i < l; i++){
		des[i] = src[i];
	}
}

int stn(char* str){
	int n = 0;
	int l = 0;
	while(*str != 0){
		n = n + *(str++); l++;
	}
	return n + l;
}

int strequ(char* a, char* b){
	return stn(a) - stn(b);
}
#endif