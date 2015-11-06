require 'argon2/constants'
require 'argon2/ffi_engine'
require 'argon2/version'
require 'argon2/errors'
require 'argon2/engine.rb'

module Argon2
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
  end
end
