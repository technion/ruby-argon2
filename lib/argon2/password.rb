module Argon2
  ##
  # Front-end API for the Argon2 module.
  #
  class Password
    # Time Cost defaults
    DEFAULT_T_COST = 2
    MIN_T_COST = 1
    MAX_T_COST = 750
    # Memory Cost Defaults
    DEFAULT_M_COST = 16
    MIN_M_COST = 1
    MAX_M_COST = 31
    # The complete Argon2 digest string (not to be confused with the checksum).
    attr_reader :digest
    # The hash portion of the stored password hash.
    attr_reader :checksum
    # The salt of the stored password hash.
    attr_reader :salt
    # Variant used (argon2[i|d|id])
    attr_reader :variant
    # The version of the argon2 algorithm used to create the hash.
    attr_reader :version
    # The time cost factor used to create the hash.
    attr_reader :t_cost
    # The memory cost factor used to create the hash.
    attr_reader :m_cost
    # The parallelism cost factor used to create the hash.
    attr_reader :p_cost

    ##
    # Class methods
    #
    class << self
      def create(password, options = {})
        raise Argon2::Errors::InvalidPassword unless password.is_a?(String)

        t_cost = options[:t_cost] || DEFAULT_T_COST
        m_cost = options[:m_cost] || DEFAULT_M_COST

        if t_cost < MIN_T_COST || t_cost > MAX_T_COST
          raise Argon2::Errors::InvalidTCost
        end

        if m_cost < MIN_M_COST || m_cost > MAX_M_COST
          raise Argon2::Errors::InvalidMCost
        end

        # TODO: Add support for changing the p_cost

        salt = options[:salt_do_not_supply] || Engine.saltgen
        secret = options[:secret]

        Argon2::Password.new(
          Argon2::Engine.hash_argon2id_encode(
            password, salt, t_cost, m_cost, secret
          )
        )
      end

      ##
      # Supports 1 and argon2id formats.
      #
      def valid_hash?(digest)
        /^\$argon2(id?|d).{,113}/ =~ digest
      end

      ##
      # Usage:
      #
      #    Argon2::Password.verify_password(password, argon2_hash)
      #    Argon2::Password.verify_password(password, argon2_hash, secret)
      #
      def verify_password(password, digest, secret = nil)
        digest = digest.to_s
        if password.is_a?(Argon2::Password)
          password == Argon2::Password.new(digest)
        else
          Argon2::Engine.argon2_verify(password, digest, secret)
        end
      end
    end

    ######################
    ## Instance Methods ##
    ######################

    ##
    # Initialize an Argon2::Password instance using any valid Argon2 digest.
    #
    def initialize(digest)
      digest = digest.to_s
      if valid_hash?(digest)
        # Split the digest into its component pieces
        split_digest = split_hash(digest)
        # Assign each piece to the Argon2::Password instance
        @digest   = digest
        @variant  = split_digest[:variant]
        @version  = split_digest[:version]
        @t_cost   = split_digest[:t_cost]
        @m_cost   = split_digest[:m_cost]
        @p_cost   = split_digest[:p_cost]
        @salt     = split_digest[:salt]
        @checksum = split_digest[:checksum]
      else
        raise Argon2::Errors::InvalidHash
      end
    end

    ##
    # Helper function to allow easily comparing an Argon2::Password against the
    # provided password and secret.
    #
    def matches?(password, secret = nil)
      self.class.verify_password(password, digest, secret)
    end

    ##
    # Compares two Argon2::Password instances to see if they come from the same
    # digest/hash.
    #
    def ==(password)
      # TODO: Should this return false instead of raising an error?
      unless password.is_a?(Argon2::Password)
        raise ArgumentError,
          'Can only compare an Argon2::Password against another Argon2::Password'
      end

      # TODO: Use secure compare to protect against timing attacks? Also, should
      #       this comparison be more strict?
      self.digest == password.digest
    end

    ##
    # Converts an Argon2::Password instance into a String.
    #
    def to_s
      digest.to_s
    end

    ##
    # Converts an Argon2::Password instance into a String.
    #
    def to_str
      digest.to_str
    end

    private

    ##
    # Helper method to allow checking if a hash is valid in the initializer.
    #
    def valid_hash?(digest)
      self.class.valid_hash?(digest)
    end

    ##
    # Helper method to extract the various values from a digest into attributes.
    #
    def split_hash(digest)
      # TODO: Is there a better way to explode the digest into attributes?
      _, variant, version, config, salt, checksum = digest.split('$')
      # Regex magic to extract the values for each setting
      version = /v=(\d+)/.match(version)
      t_cost  = /t=(\d+),/.match(config)
      m_cost  = /m=(\d+),/.match(config)
      p_cost  = /p=(\d+)/.match(config)

      # Make sure none of the values are missing
      raise Argon2::Errors::InvalidVersion if version.nil?
      raise Argon2::Errors::InvalidTCost   if t_cost.nil?
      raise Argon2::Errors::InvalidMCost   if m_cost.nil?
      raise Argon2::Errors::InvalidPCost   if p_cost.nil?
      # Undo the 2^m_cost operation when encoding the hash to get the original
      # m_cost input back.
      m_cost = Math.log2(m_cost[1].to_i).to_i

      {
        variant: variant.to_str,
        version: version[1].to_i,
        t_cost: t_cost[1].to_i,
        m_cost: m_cost,
        p_cost: p_cost[1].to_i,
        salt: salt.to_str,
        checksum: checksum.to_str
      }
    end
  end
end
