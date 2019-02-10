# frozen_string_literal: true

require 'argon2/constants'
require 'argon2/ffi_engine'
require 'argon2/version'
require 'argon2/errors'
require 'argon2/engine.rb'

module Argon2
  # Front-end API for the Argon2 module.
  class Password
    def initialize(options = {})
      @t_cost = options[:t_cost] || 2
      raise ArgonHashFail, "Invalid t_cost" if @t_cost < 1 || @t_cost > 750
      @m_cost = options[:m_cost] || 16
      raise ArgonHashFail, "Invalid m_cost" if @m_cost < 1 || @m_cost > 31
      @salt = options[:salt_do_not_supply] || Engine.saltgen
      @secret = options[:secret]
    end

    def create(pass)
      raise ArgonHashFail, "Invalid password (expected string)" unless
        pass.is_a?(String)

      Argon2::Engine.hash_argon2id_encode(
              pass, @salt, @t_cost, @m_cost, @secret)
    end

    # Helper class, just creates defaults and calls hash()
    def self.create(pass)
      argon2 = Argon2::Password.new
      argon2.create(pass)
    end

    # Supports 1 and argon2id formats.
    def self.valid_hash?(hash)
      /^\$argon2(id?|d).{,113}/ =~ hash
    end

    def self.verify_password(pass, hash, secret = nil)
      raise ArgonHashFail, "Invalid hash" unless valid_hash?(hash)

      Argon2::Engine.argon2_verify(pass, hash, secret)
    end
  end
end
