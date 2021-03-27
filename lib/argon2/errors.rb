# frozen_string_literal: true

module Argon2
  ##
  # Generic error to catch anything the Argon2 ruby library throws.
  #
  class Error < StandardError; end

  ##
  # Various errors for invalid parameters passed to the library.
  #
  # WIP
  #
  module Errors
    class InvalidHash < Argon2::Error; end

    ##
    # Not used directly, but allows developers to catch any cost exception
    # regardless of which cost is invalid.
    #
    class InvalidCost < Argon2::Error; end

    class InvalidTCost < InvalidCost; end

    class InvalidMCost < InvalidCost; end

    class InvalidPassword < Argon2::Error
      def initialize(msg="Invalid password (expected a String)")
        super
      end
    end

    class InvalidSaltSize < Argon2::Error; end

    class InvalidOutputLength < Argon2::Error; end

    class ExtError < Argon2::Error; end
  end

  ##
  # Defines an array of errors that matches the enum list of errors from
  # argon2.h. This allows return values to propagate errors through the FFI.
  #
  ERRORS = %w[
    ARGON2_OK
    ARGON2_OUTPUT_PTR_NULL
    ARGON2_OUTPUT_TOO_SHORT
    ARGON2_OUTPUT_TOO_LONG
    ARGON2_PWD_TOO_SHORT
    ARGON2_PWD_TOO_LONG
    ARGON2_SALT_TOO_SHORT
    ARGON2_SALT_TOO_LONG
    ARGON2_AD_TOO_SHORT
    ARGON2_AD_TOO_LONG
    ARGON2_SECRET_TOO_SHORT
    ARGON2_SECRET_TOO_LONG
    ARGON2_TIME_TOO_SMALL
    ARGON2_TIME_TOO_LARGE
    ARGON2_MEMORY_TOO_LITTLE
    ARGON2_MEMORY_TOO_MUCH
    ARGON2_LANES_TOO_FEW
    ARGON2_LANES_TOO_MANY
    ARGON2_PWD_PTR_MISMATCH
    ARGON2_SALT_PTR_MISMATCH
    ARGON2_SECRET_PTR_MISMATCH
    ARGON2_AD_PTR_MISMATCH
    ARGON2_MEMORY_ALLOCATION_ERROR
    ARGON2_FREE_MEMORY_CBK_NULL
    ARGON2_ALLOCATE_MEMORY_CBK_NULL
    ARGON2_INCORRECT_PARAMETER
    ARGON2_INCORRECT_TYPE
    ARGON2_OUT_PTR_MISMATCH
    ARGON2_THREADS_TOO_FEW
    ARGON2_THREADS_TOO_MANY
    ARGON2_MISSING_ARGS
    ARGON2_ENCODING_FAIL
    ARGON2_DECODING_FAIL
    ARGON2_THREAD_FAIL
  ].freeze
end
