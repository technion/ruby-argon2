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
    # Expose constants for the options supported and default used for passwords.
    DEFAULT_T_COST = 2
    DEFAULT_M_COST = 16
    DEFAULT_P_COST = 1
    MIN_T_COST = 1
    MAX_T_COST = 750
    MIN_M_COST = 1
    MAX_M_COST = 31
    MIN_P_COST = 1
    MAX_P_COST = 8

    def initialize(options = {})
      @t_cost = options[:t_cost] || DEFAULT_T_COST
      raise ArgonHashFail, "Invalid t_cost" if @t_cost < MIN_T_COST || @t_cost >  MAX_T_COST

      @m_cost = options[:m_cost] || DEFAULT_M_COST
      raise ArgonHashFail, "Invalid m_cost" if @m_cost < MIN_M_COST || @m_cost >  MAX_M_COST

      @p_cost = options[:p_cost] || DEFAULT_P_COST
      raise ArgonHashFail, "Invalid p_cost" if @p_cost < MIN_P_COST || @p_cost >  MAX_P_COST

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
