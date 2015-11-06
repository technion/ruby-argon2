# Argon Wrapper Makefile
# This file is based on the original Argon2 reference
# Argon2 source code package
# 
# This work is licensed under a Creative Commons CC0 1.0 License/Waiver.
# 
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
#

DIST_SRC = ../phc-winner-argon2/src
CC = gcc
SRC = $(DIST_SRC)/argon2.c $(DIST_SRC)/core.c $(DIST_SRC)/blake2/blake2b.c $(DIST_SRC)/thread.c argon_wrap.c
OBJ = $(SRC:.c=.o)

CFLAGS = -std=c89 -pthread -O3 -Wall -g

OPT=TRUE
ifeq ($(OPT), TRUE)
	CFLAGS += -march=native
	SRC += $(DIST_SRC)/opt.c
else
	SRC += $(DIST_SRC)/ref.c
endif

BUILD_PATH := $(shell pwd)
KERNEL_NAME := $(shell uname -s)

LIB_NAME=argon2_wrap
ifeq ($(KERNEL_NAME), Linux)
	LIB_EXT := so
	LIB_CFLAGS := -shared -fPIC
	LIB_PATH := -Wl,-rpath=$(BUILD_PATH)
endif
ifeq ($(KERNEL_NAME), NetBSD)
	LIB_EXT := so
	LIB_CFLAGS := -shared -fPIC
	LIB_PATH := -Wl,-rpath=$(BUILD_PATH)
endif
ifeq ($(KERNEL_NAME), Darwin)
	LIB_EXT := dylib
	LIB_CFLAGS := -dynamiclib -install_name @rpath/lib$(LIB_NAME).$(LIB_EXT)
	LIB_PATH := -Xlinker -rpath -Xlinker $(BUILD_PATH)
endif
ifeq ($(findstring MINGW, $(KERNEL_NAME)), MINGW)
	LIB_EXT := dll
	LIB_CFLAGS := -shared -Wl,--out-implib,lib$(LIB_NAME).$(LIB_EXT).a
	LIB_PATH := -Wl,-rpath=$(BUILD_PATH)
endif
ifeq ($(KERNEL_NAME), $(filter $(KERNEL_NAME),OpenBSD FreeBSD))
	LIB_EXT := so
	LIB_CFLAGS := -shared -fPIC
	LIB_PATH := -Wl,-rpath=$(BUILD_PATH)
endif

LIB_SH := lib$(LIB_NAME).$(LIB_EXT)

all: libs 
libs: $(SRC)
		$(CC) $(CFLAGS) $(LIB_CFLAGS) $^ -o libargon2_wrap.so

#Deliberately avoiding the CFLAGS for our test cases - disable optimise and
#C89
test: $(SRC) test.c
		$(CC) -pthread -O3 -Wall -g $^ -o tests
		./tests

clean:
	rm -rf tests libargon2_wrap.so

install:
	echo none
