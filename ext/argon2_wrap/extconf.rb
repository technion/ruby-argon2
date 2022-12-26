# frozen_string_literal: true
require 'mkmf'
$CFLAGS += " -march=native -lpthread"

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

File.open("Makefile", "at") do |mk|
  mk.print(<<~EOF)
test: $(SRC) test.c
	clang -pthread -O3 -fsanitize=address -fsanitize=undefined -Wall -g $^ -o tests $(CFLAGS)
	./tests
  EOF
end

create_makefile('libargon2_wrap')
