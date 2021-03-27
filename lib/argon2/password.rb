module Argon2
  ##
  # Front-end API for the Argon2 module.
  #
  class Password
    def initialize(options = {})
      @t_cost = options[:t_cost] || 2
      raise ::Argon2::Errors::InvalidTCost if @t_cost < 1 || @t_cost > 750

      @m_cost = options[:m_cost] || 16
      raise ::Argon2::Errors::InvalidMCost if @m_cost < 1 || @m_cost > 31

      @salt = options[:salt_do_not_supply] || Engine.saltgen
      @secret = options[:secret]
    end

    def create(password)
      raise ::Argon2::Errors::InvalidPassword unless password.is_a?(String)

      ::Argon2::Engine.hash_argon2id_encode(
        password, @salt, @t_cost, @m_cost, @secret
      )
    end

    # Helper class, just creates defaults and calls hash()
    def self.create(password)
      argon2 = Argon2::Password.new
      argon2.create(password)
    end

    # Supports 1 and argon2id formats.
    def self.valid_hash?(hash)
      /^\$argon2(id?|d).{,113}/ =~ hash
    end

    def self.verify_password(password, hash, secret = nil)
      raise ArgonHashFail, "Invalid hash" unless valid_hash?(hash)

      ::Argon2::Engine.argon2_verify(password, hash, secret)
    end
  end
end
