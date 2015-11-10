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
      raise ArgonHashFail, "Invalid t_cost" if @t_cost < 1 || @t_cost > 10
      @m_cost = options[:m_cost] || 16
      raise ArgonHashFail, "Invalid m_cost" if @t_cost < 1 || @t_cost > 31
      @salt = options[:salt_do_not_supply] || Engine.saltgen
      @secret = options[:secret]
    end

    def hash(pass)
      # It is technically possible to include NULL bytes, however our C
      # uses strlen(). It is not deemed suitable to accept a user password
      # with such a character.
      raise ArgonHashFail, "NULL bytes not permitted" if /\0/.match(pass)
      Argon2::Engine.hash_argon2i_encode(
              pass, @salt, @t_cost, @m_cost, @secret)
    end

    #Helper class, just creates defaults and calls hash()
    def self.hash(pass)
      argon2 = Argon2::Password.new
      argon2.hash(pass)
    end

    def self.verify_password(pass, hash)
      raise ArgonHashFail, "Invalid hash" unless 
        /^\$argon2i\$.{,110}/.match hash
      Argon2::Engine.argon2i_verify(pass, hash, nil)
    end
  end
end
