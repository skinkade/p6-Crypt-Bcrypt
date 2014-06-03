#
# Written and revised by Solar Designer <solar at openwall.com> in 2000-2011.
# No copyright is claimed, and the software is hereby placed in the public
# domain.  In case this attempt to disclaim copyright and place the software
# in the public domain is deemed null and void, then the software is
# Copyright (c) 2000-2011 Solar Designer and it is hereby released to the
# general public under the following terms:
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted.
#
# There's ABSOLUTELY NO WARRANTY, express or implied.
#
# See crypt_blowfish.c for more information.
#

CC = gcc
AS = $(CC)
LD = $(CC)
RM = rm -f
CFLAGS = -W -Wall -Wbad-function-cast -Wcast-align -Wcast-qual -Wmissing-prototypes -Wstrict-prototypes -Wshadow -Wundef -Wpointer-arith -O2 -fomit-frame-pointer -fPIC -funroll-loops
ASFLAGS = -c
LDFLAGS = -s

SHARED_BIN = crypt_blowfish.so

BLOWFISH_OBJS = \
	crypt_blowfish.o x86.o

CRYPT_OBJS = \
	$(BLOWFISH_OBJS) crypt_gensalt.o wrapper.o

TEST_OBJS = \
	$(BLOWFISH_OBJS) crypt_gensalt.o crypt_test.o

TEST_THREADS_OBJS = \
	$(BLOWFISH_OBJS) crypt_gensalt.o crypt_test_threads.o

SHARED_OBJS= \
	$(SHARED_BIN)

all: $(CRYPT_OBJS) shared_link

check: crypt_test
	./crypt_test

crypt_test: $(TEST_OBJS)
	$(LD) $(LDFLAGS) $(TEST_OBJS) -o $@

crypt_test.o: wrapper.c ow-crypt.h crypt_blowfish.h crypt_gensalt.h
	$(CC) -c $(CFLAGS) wrapper.c -DTEST -o $@

check_threads: crypt_test_threads
	./crypt_test_threads

crypt_test_threads: $(TEST_THREADS_OBJS)
	$(LD) $(LDFLAGS) $(TEST_THREADS_OBJS) -lpthread -o $@

crypt_test_threads.o: wrapper.c ow-crypt.h crypt_blowfish.h crypt_gensalt.h
	$(CC) -c $(CFLAGS) wrapper.c -DTEST -DTEST_THREADS=4 -o $@

crypt_blowfish.o: crypt_blowfish.h
crypt_gensalt.o: crypt_gensalt.h
wrapper.o: crypt.h ow-crypt.h crypt_blowfish.h crypt_gensalt.h

shared_link:
	$(CC) -shared -s -o $(SHARED_BIN) *.o

.c.o:
	$(CC) -c $(CFLAGS) $*.c

.S.o:
	$(AS) $(ASFLAGS) $*.S

clean:
	$(RM) crypt_test crypt_test_threads *.o *.so core
