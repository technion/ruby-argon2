require 'argon2/constants'
require 'argon2/ffi_engine'
require 'argon2/version'
require 'argon2/errors'
require 'argon2/engine.rb'

module Argon2
  # Front-end API for the Argon2 module.
  class Password
    def initialize(options = {})
      #TODO: Verify inputs
      @t_cost = options[:t_cost] || 2
      @m_cost = options[:m_cost] || 16
      @salt = options[:salt_do_not_supply] || Engine.saltgen
    end

    def hash(pass)
      Argon2::Engine.hash_argon2i_encode(
              pass, @salt, @t_cost, @m_cost)
    end

    #Helper class, just creates defaults and calls hash()
    def self.hash(pass)
      argon2 = Argon2::Password.new
      argon2.hash(pass)
    end

    def self.verify_password(pass, hash)
      #TODO: Basic verify
      Argon2::Engine.argon2i_verify(pass, hash)
    end
  end
end
