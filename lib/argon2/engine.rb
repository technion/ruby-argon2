require 'securerandom'

module Argon2
  class Engine
    def self.saltgen
      SecureRandom.random_bytes(Argon2::Constants::SALT_LEN)
    end
  end
end

