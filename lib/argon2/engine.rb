# frozen_string_literal: true

require 'securerandom'

module Argon2
  ##
  # TODO: Document Engine class, and how it differs from the ffi_engine class.
  #
  class Engine
    ##
    # Generates a random, binary string for use as a salt.
    #
    def self.saltgen
      SecureRandom.random_bytes(Argon2::Constants::SALT_LEN)
    end
  end
end
