# frozen_string_literal: true

require 'argon2/constants'
require 'argon2/ffi_engine'
require 'argon2/version'
require 'argon2/errors'
require 'argon2/engine'
require 'argon2/hash_format'

module Argon2
  # Front-end API for the Argon2 module.
  class Password
    def initialize(options = {})
      @t_cost = options[:t_cost] || 2
      raise ArgonHashFail, "Invalid t_cost" if @t_cost < 1 || @t_cost > 750

      @m_cost = options[:m_cost] || 16
      raise ArgonHashFail, "Invalid m_cost" if @m_cost < 1 || @m_cost > 31

      @p_cost = options[:p_cost] || 1
      raise ArgonHashFail, "Invalid p_cost" if @p_cost < 1 || @p_cost > 8

      @salt_do_not_supply = options[:salt_do_not_supply]
      @secret = options[:secret]
    end

    def create(pass)
      raise ArgonHashFail, "Invalid password (expected string)" unless
        pass.is_a?(String)

      # Ensure salt is freshly generated unless it was intentionally supplied.
      salt = @salt_do_not_supply || Engine.saltgen

      Argon2::Engine.hash_argon2id_encode(
        pass, salt, @t_cost, @m_cost, @p_cost, @secret)
    end

    # Helper class, just creates defaults and calls hash()
    def self.create(pass, options = {})
      argon2 = Argon2::Password.new(options)
      argon2.create(pass)
    end

    def self.valid_hash?(hash)
      Argon2::HashFormat.valid_hash?(hash)
    end

    def self.verify_password(pass, hash, secret = nil)
      raise ArgonHashFail, "Invalid hash" unless valid_hash?(hash)

      Argon2::Engine.argon2_verify(pass, hash, secret)
    end
  end
end
