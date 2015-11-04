require "argon2/version"
require 'ffi'

module Argon2
  module Ext
    extend FFI::Library
    ffi_lib './ext/phc-winner-argon2/libargon2.so'
#/**
# * Function to hash the inputs in the memory-hard fashion (uses Argon2i)
# * @param  out  Pointer to the memory where the hash digest will be written
# * @param  outlen Digest length in bytes
# * @param  in Pointer to the input (password)
# * @param  inlen Input length in bytes
# * @param  salt Pointer to the salt
# * @param  saltlen Salt length in bytes
# * @pre    @a out must have at least @a outlen bytes allocated
# * @pre    @a in must be at least @inlen bytes long
# * @pre    @a saltlen must be at least @saltlen bytes long
# * @return Zero if successful, 1 otherwise.
# */
#int hash_argon2i(void *out, size_t outlen, const void *in, size_t inlen,
#                 const void *salt, size_t saltlen, unsigned int t_cost,
#                 unsigned int m_cost);

    attach_function :hash_argon2i, [:pointer, :size_t, :pointer, :size_t, 
   :pointer, :size_t, :uint, :uint ], :int, :blocking => true
  end

  def Argon2.hash_argon2i(password, salt)
    result = ''
    FFI::MemoryPointer.new(:char, 32) do |buffer|
      ret = Ext.hash_argon2i(buffer, 32, password, password.length, salt, salt.length, 2, (1<<16))
      fail "Hash failed" unless ret == 0
      result = buffer.read_string(32)
    end
     result.unpack('H*').join
  end
end
