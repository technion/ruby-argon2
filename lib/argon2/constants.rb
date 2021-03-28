# frozen_string_literal: true

module Argon2
  ##
  # Constants utilised in several parts of the Argon2 module
  #
  module Constants
    SALT_LEN   = 16  # Standard recommendation from the Argon2 spec
    OUT_LEN    = 32  # Binary, unencoded output
    ENCODE_LEN = 108 # Encoded output
  end
end
