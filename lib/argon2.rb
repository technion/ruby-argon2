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
    ##
    # Takes the input password and creates an Argon2 hash using the provided
    # settings
    #
    def self.create(pass, options = {})
      raise Argon2::Error, "Invalid password (expected string)" unless
        pass.is_a?(String)

      t_cost = options[:t_cost] || 2
      raise Argon2::Error, "Invalid t_cost" if t_cost < 1 || t_cost > 750

      m_cost = options[:m_cost] || 16
      raise Argon2::Error, "Invalid m_cost" if m_cost < 1 || m_cost > 31

      p_cost = options[:p_cost] || 1
      raise Argon2::Error, "Invalid p_cost" if p_cost < 1 || p_cost > 8

      salt = options[:salt_do_not_supply] || Engine.saltgen
      secret = options[:secret]

      Argon2::Engine.hash_argon2id_encode(
        pass, salt, t_cost, m_cost, p_cost, secret)
    end

    def self.valid_hash?(hash)
      Argon2::HashFormat.valid_hash?(hash)
    end

    def self.verify_password(pass, hash, secret = nil)
      raise Argon2::Error, "Invalid hash" unless valid_hash?(hash)

      Argon2::Engine.argon2_verify(pass, hash, secret)
    end
  end
end
