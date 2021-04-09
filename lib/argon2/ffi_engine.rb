# frozen_string_literal: true

require 'ffi'
require 'ffi-compiler/loader'

module Argon2
  # Direct external bindings. Call these methods via the Engine class to ensure points are dealt with
  module Ext
    extend FFI::Library
    ffi_lib FFI::Compiler::Loader.find(FFI::Platform.windows? ? 'libargon2_wrap' : 'argon2_wrap')

    # int argon2i_hash_raw(const uint32_t t_cost, const uint32_t m_cost,
    #   const uint32_t parallelism, const void *pwd,
    #   const size_t pwdlen, const void *salt,
    #   const size_t saltlen, void *hash, const size_t hashlen);

    attach_function :argon2i_hash_raw, %i[
      uint uint uint pointer
      size_t pointer size_t pointer size_t
    ], :int, :blocking => true

    # int argon2id_hash_raw(const uint32_t t_cost, const uint32_t m_cost,
    #   const uint32_t parallelism, const void *pwd,
    #   const size_t pwdlen, const void *salt,
    #   const size_t saltlen, void *hash, const size_t hashlen)
    attach_function :argon2id_hash_raw, %i[
      uint uint uint pointer
      size_t pointer size_t pointer size_t
    ], :int, :blocking => true

    # void argon2_wrap(uint8_t *out, char *pwd, size_t pwdlen,
    # uint8_t *salt, uint32_t saltlen, uint32_t t_cost,
    #    uint32_t m_cost, uint32_t lanes,
    #    uint8_t *secret, uint32_t secretlen)
    attach_function :argon2_wrap, %i[
      pointer pointer size_t pointer uint uint
      uint uint pointer size_t
    ], :int, :blocking => true

    # int argon2i_verify(const char *encoded, const void *pwd,
    # const size_t pwdlen);
    attach_function :wrap_argon2_verify, %i[pointer pointer size_t
      pointer size_t], :int, :blocking => true
  end

  # The engine class shields users from the FFI interface.
  # It is generally not advised to directly use this class.
  class Engine
    def self.hash_argon2i(password, salt, t_cost, m_cost, out_len = nil)
      out_len = (out_len || Constants::OUT_LEN).to_i
      raise ArgonHashFail, "Invalid output length" if out_len < 1

      result = ''
      FFI::MemoryPointer.new(:char, out_len) do |buffer|
        ret = Ext.argon2i_hash_raw(t_cost, 1 << m_cost, 1, password,
                                   password.length, salt, salt.length,
                                   buffer, out_len)
        raise ArgonHashFail, ERRORS[ret.abs] unless ret.zero?

        result = buffer.read_string(out_len)
      end
      result.unpack('H*').join
    end

    def self.hash_argon2id(password, salt, t_cost, m_cost, p_cost, out_len = nil)
      out_len = (out_len || Constants::OUT_LEN).to_i
      raise ArgonHashFail, "Invalid output length" if out_len < 1

      result = ''
      FFI::MemoryPointer.new(:char, out_len) do |buffer|
        ret = Ext.argon2id_hash_raw(t_cost, 1 << m_cost, p_cost, password,
                                    password.length, salt, salt.length,
                                    buffer, out_len)
        raise ArgonHashFail, ERRORS[ret.abs] unless ret.zero?

        result = buffer.read_string(out_len)
      end
      result.unpack('H*').join
    end

    def self.hash_argon2id_encode(password, salt, t_cost, m_cost, p_cost, secret)
      result = ''
      secretlen = secret.nil? ? 0 : secret.bytesize
      passwordlen = password.nil? ? 0 : password.bytesize
      raise ArgonHashFail, "Invalid salt size" if salt.length != Constants::SALT_LEN

      FFI::MemoryPointer.new(:char, Constants::ENCODE_LEN) do |buffer|
        ret = Ext.argon2_wrap(buffer, password, passwordlen,
                              salt, salt.length, t_cost, (1 << m_cost),
                              p_cost, secret, secretlen)
        raise ArgonHashFail, ERRORS[ret.abs] unless ret.zero?

        result = buffer.read_string(Constants::ENCODE_LEN)
      end
      result.delete "\0"
    end

    def self.argon2_verify(pwd, hash, secret)
      secretlen = secret.nil? ? 0 : secret.bytesize
      passwordlen = pwd.nil? ? 0 : pwd.bytesize

      ret = Ext.wrap_argon2_verify(hash, pwd, passwordlen, secret, secretlen)
      return false if ERRORS[ret.abs] == 'ARGON2_DECODING_FAIL'
      raise ArgonHashFail, ERRORS[ret.abs] unless ret.zero?

      true
    end
  end
end
