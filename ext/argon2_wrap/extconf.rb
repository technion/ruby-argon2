# frozen_string_literal: true
require 'mkmf'
$CFLAGS += " -march=native -lpthread"

case RUBY_PLATFORM
when /darwin/
  $CFLAGS += " -bundle"
else
  $CFLAGS += " -shared -fPIC"
end

find_header("argon2.h", "../../../../ext/phc-winner-argon2/include", "../phc-winner-argon2/include")
find_header("argon2.c", "../../../../ext/phc-winner-argon2/src", "../phc-winner-argon2/src")
$srcs = %w( ../phc-winner-argon2/src/argon2.c
 ../phc-winner-argon2/src/core.c
  ../phc-winner-argon2/src/blake2/blake2b.c
  ../phc-winner-argon2/src/thread.c
  ../phc-winner-argon2/src/encoding.c
  ../phc-winner-argon2/src/opt.c
  argon_wrap.c)
$objs = $srcs.map { |x| x.gsub /\.c/, '.o' }
puts $CFLAGS
create_makefile('libargon2_wrap')

File.open("Makefile", "at") do |mk|
  mk.print(<<~EOF)
DIST_SRC = ../phc-winner-argon2/src
SRC = $(DIST_SRC)/argon2.c $(DIST_SRC)/core.c $(DIST_SRC)/blake2/blake2b.c $(DIST_SRC)/thread.c $(DIST_SRC)/encoding.c argon_wrap.c $(DIST_SRC)/opt.c

OBJ = $(SRC:.c=.o)
CFLAGS = -pthread -O3 -Wall -g -I../phc-winner-argon2/include -I../phc-winner-argon2/src
test: $(SRC) test.c
	clang -pthread -O3 -fsanitize=address -fsanitize=undefined -Wall -g $^ -o tests $(CFLAGS)
	./tests
  EOF
end
