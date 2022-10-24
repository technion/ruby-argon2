# frozen_string_literal: true

module Argon2
  ##
  # Get the values from an Argon2 compatible string.
  #
  class HashFormat
    attr_reader :variant, :version, :t_cost, :m_cost, :p_cost, :salt, :checksum

    # FIXME: Reduce complexity/AbcSize
    # rubocop:disable Metrics/AbcSize
    def initialize(digest)
      digest = digest.to_s unless digest.is_a?(String)

      raise Argon2::ArgonHashFail, 'Invalid Argon2 hash' unless self.class.valid_hash?(digest)

      _, variant, version, config, salt, checksum = digest.split('$')
      # Regex magic to extract the values for each setting
      version = /v=(\d+)/.match(version)
      t_cost  = /t=(\d+),/.match(config)
      m_cost  = /m=(\d+),/.match(config)
      p_cost  = /p=(\d+)/.match(config)

      # Make sure none of the values are missing
      raise Argon2::ArgonHashFail, 'Invalid Argon2 version' if version.nil?
      raise Argon2::ArgonHashFail, 'Invalid Argon2 time cost' if t_cost.nil?
      raise Argon2::ArgonHashFail, 'Invalid Argon2 memory cost' if m_cost.nil?
      raise Argon2::ArgonHashFail, 'Invalid Argon2 parallelism cost' if p_cost.nil?

      @variant  = variant.to_str
      @version  = version[1].to_i
      @t_cost   = t_cost[1].to_i
      @m_cost   = m_cost[1].to_i
      @p_cost   = p_cost[1].to_i
      @salt     = salt.to_str
      @checksum = checksum.to_str
    end
    # rubocop:enable Metrics/AbcSize

    ##
    # Checks whether a given digest is a valid Argon2 hash.
    #
    # Supports 1 and argon2id formats.
    #
    def self.valid_hash?(digest)
      /^\$argon2(id?|d).{,113}/ =~ digest
    end
  end
end
