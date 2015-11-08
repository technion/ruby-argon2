require 'ffi'
require 'ffi-compiler/loader'

module Argon2
  module Ext
    #Direct external bindings. Call these methods via the Engine class to ensure points are dealt with
    extend FFI::Library
    ffi_lib FFI::Compiler::Loader.find('argon2_wrap')
    #int argon2i_hash_raw(const uint32_t t_cost, const uint32_t m_cost,
    #   const uint32_t parallelism, const void *pwd,
    #   const size_t pwdlen, const void *salt,
    #   const size_t saltlen, void *hash, const size_t hashlen);

   attach_function :argon2i_hash_raw, [:uint, :uint, :uint, :pointer, 
     :size_t, :pointer, :size_t, :pointer, :size_t ], :int, :blocking => true

    #void argon2_wrap(uint8_t *out, char *pwd, uint8_t *salt, uint32_t t_cost,
    #    uint32_t m_cost, uint32_t lanes);
    attach_function :argon2_wrap, [:pointer, :pointer, :pointer, :uint, :uint, :uint], :uint, :blocking => true

    #int argon2i_verify(const char *encoded, const void *pwd, const size_t pwdlen);
    attach_function :argon2i_verify, [:pointer, :pointer, :size_t], :int, :blocking => true

  end

  class Engine
    # The engine class shields users from the FFI interface.
    # It is generally not advised to directly use this class.
    def self.hash_argon2i(password, salt, t_cost, m_cost)
      result = ''
      FFI::MemoryPointer.new(:char, Constants::OUT_LEN) do |buffer|
        ret = Ext.argon2i_hash_raw(t_cost, 1<<m_cost, 1, password, password.length, salt, salt.length, 
            buffer, Constants::OUT_LEN)
        raise ArgonHashFail.new(ERRORS[ret]) unless ret == 0
        result = buffer.read_string(Constants::OUT_LEN)
      end
       result.unpack('H*').join
    end

    def self.hash_argon2i_encode(password, salt, t_cost, m_cost)
      result = ''
      if salt.length != Constants::SALT_LEN
        raise ArgonHashFail.new("Invalid salt size") 
      end
      FFI::MemoryPointer.new(:char, 300) do |buffer|
        ret = Ext.argon2_wrap(buffer, password, salt, t_cost, (1<<m_cost), 1)
        raise ArgonHashFail.new(ERRORS[ret]) unless ret == 0
        result = buffer.read_string(300)
      end
      result.gsub("\0", '')
    end

    def self.argon2i_verify(pwd, hash)
      ret = Ext.argon2i_verify(hash, pwd, pwd.length)
      return false if ERRORS[ret] =='ARGON2_DECODING_FAIL'
      raise ArgonHashFail.new(ERRORS[ret]) unless ret == 0
      true
    end

  end
end
