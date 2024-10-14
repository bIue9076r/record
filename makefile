all: ldb str
	@echo "[Build Done]"

test: ldb str ./test.c
	@gcc test.c ldb.o str.o -o ./test.out
	@echo "[test.c done]"

ldb: ./ldb.c ./ldb.h
	@gcc -c ldb.c -o ldb.o
	@echo "[ldb.c Done]"

str: ./str.c ./str.h
	@gcc -c str.c -o str.o
	@echo "[str.c Done]"

clean:
	@rm ./ldb.o
	@rm ./str.o
	@echo "[Cleaned]"
