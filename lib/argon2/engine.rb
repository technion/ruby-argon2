# frozen_string_literal: true

require 'securerandom'

module Argon2
  class Engine
    ##
    # Generates a random, binary string for use as a salt.
    #
    def self.saltgen
      SecureRandom.random_bytes(Argon2::Constants::SALT_LEN)
    end
  end
end
