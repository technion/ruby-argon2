# frozen_string_literal: true
require 'mkmf'
create_makefile('libargon2_wrap')
File.unlink('Makefile')
File.rename('Makefile.real', 'Makefile')
