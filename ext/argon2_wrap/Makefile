all: argon_wrap.c 
	gcc -std=c89 -pthread -O3 -Wall -g -shared -fPIC ../phc-winner-argon2/src/argon2.c ../phc-winner-argon2/src/core.c ../phc-winner-argon2/src/blake2/blake2b.c ../phc-winner-argon2/src/thread.c ../phc-winner-argon2/src/ref.c -I../phc-winner-argon2/src  argon_wrap.c  -o libargon_wrap.so


test: test.c argon_wrap.c
	clang -Wall -fsanitize=undefined -fsanitize=address argon_wrap.c test.c ../phc-winner-argon2/libargon2.a -lpthread -o tests
