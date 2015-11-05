require 'ffi'

module Argon2
  module Ext
    extend FFI::Library
    ffi_lib './ext/argon2_wrap/libargon_wrap.so'
#int hash_argon2i(void *out, size_t outlen, const void *in, size_t inlen,
#                 const void *salt, size_t saltlen, unsigned int t_cost,
#                 unsigned int m_cost);

   attach_function :hash_argon2i, [:pointer, :size_t, :pointer, :size_t, 
   :pointer, :size_t, :uint, :uint ], :int, :blocking => true

#void argon2_wrap(uint8_t *out, char *pwd, uint8_t *salt, uint32_t t_cost,
#        uint32_t m_cost, uint32_t lanes);
    attach_function :argon2_wrap, [:pointer, :pointer, :pointer, :uint, :uint, :uint], :int, :blocking => true

  end

  class Engine
    def self.hash_argon2i(password, salt, t_cost, m_cost)
      result = ''
      FFI::MemoryPointer.new(:char, 32) do |buffer|
        ret = Ext.hash_argon2i(buffer, 32, password, password.length, salt, salt.length, t_cost, (1<<m_cost))
        raise ArgonHashFail.new(ERRORS[ret]) unless ret == 0
        result = buffer.read_string(32)
      end
       result.unpack('H*').join
    end

    def self.hash_argon2i_encode(password, salt, t_cost, m_cost)
      result = ''
      raise ArgonHashFail.new("Invalid salt size") unless salt.length == 16
      FFI::MemoryPointer.new(:char, 300) do |buffer|
        ret = Ext.argon2_wrap(buffer, password, salt, t_cost, (1<<m_cost), 1)
        raise ArgonHashFail.new(ERRORS[ret]) unless ret == 0
        result = buffer.read_string(300)
      end
      result.gsub("\0", '')
    end
  end
end
