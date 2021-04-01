# frozen_string_literal: true

module Argon2
  ##
  # Generic error to catch anything the Argon2 ruby library throws.
  #
  class Error < StandardError; end

  ##
  # Various errors for invalid parameters passed to the library.
  #
  module Errors
    ##
    # Raised when an invalid Argon2 hash has been passed to Argon2::Password.new
    #
    class InvalidHash < Argon2::Error; end

    ##
    # Raised when a valid Argon2 hash was passed to Argon2::Password, but the
    # version information is missing or corrupted.
    #
    class InvalidVersion < InvalidHash; end

    ##
    # Abstract error class that isn't raised directly, but allows you to catch
    # any cost error, regardless of which value was invalid.
    #
    class InvalidCost < InvalidHash; end

    ##
    # Raised when an invalid time cost has been passed to
    # Argon2::Password.create, or the hash passed to Argon2::Password.new
    # was valid but the time cost information is missing or corrupted.
    #
    class InvalidTCost < InvalidCost; end

    ##
    # Raised when an invalid memory cost has been passed to
    # Argon2::Password.create, or the hash passed to Argon2::Password.new
    # was valid but the memory cost information is missing or corrupted.
    #
    class InvalidMCost < InvalidCost; end

    ##
    # Raised when an invalid parallelism cost has been passed to
    # Argon2::Password.create, or the hash passed to Argon2::Password.new
    # was valid but the parallelism cost information is missing or corrupted.
    #
    class InvalidPCost < InvalidCost; end

    ##
    # Raised when a non-string object is passed to Argon2::Password.create
    #
    class InvalidPassword < Argon2::Error
      def initialize(msg = "Invalid password (expected a String)")
        super
      end
    end

    ##
    # Raised when an invalid salt length was passed to
    # Argon2::Engine.hash_argon2id_encode
    #
    class InvalidSaltSize < Argon2::Error; end

    ##
    # Raised when the output length passed to Argon2::Engine.hash_argon2i or
    # Argon2::Engine.hash_argon2id is invalid.
    #
    class InvalidOutputLength < Argon2::Error; end

    ##
    # Error raised by/caught from the Argon2 C Library.
    #
    # See Argon2::ERRORS for a full list of related error codes.
    #
    class ExtError < Argon2::Error; end
  end

  ##
  # Defines an array of errors that matches the enum list of errors from
  # argon2.h. This allows return values to propagate errors through the FFI. Any
  # error from this list will be thrown as an Argon2::Errors::ExtError
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
