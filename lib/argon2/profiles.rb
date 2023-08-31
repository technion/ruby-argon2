# frozen_string_literal: true

module Argon2
  # Contains named profiles of different common cost parameter sets
  class Profiles
    def self.[](name)
      name = name.upcase.to_sym
      raise NotImplementedError unless const_defined?(name)

      const_get(name)
    end

    def self.to_a
      constants.map(&:downcase)
    end

    def self.to_h
      to_a.reduce({}) { |h, name| h.update(name => self[name]) }
    end

    # https://datatracker.ietf.org/doc/html/rfc9106#name-argon2-algorithm
    # FIRST RECOMMENDED option per RFC 9106.
    RFC_9106_HIGH_MEMORY = {
      t_cost: 1,
      m_cost: 21, # 2 GiB
      p_cost: 4
    }.freeze

    # SECOND RECOMMENDED option per RFC 9106.
    RFC_9106_LOW_MEMORY = {
      t_cost: 3,
      m_cost: 16, # 64 MiB
      p_cost: 4
    }.freeze

    # The default values ruby-argon2 had before using RFC 9106 recommendations
    PRE_RFC_9106 = {
      t_cost: 2,
      m_cost: 16, # 64 MiB
      p_cost: 1
    }.freeze

    # Only use for fast testing. Insecure otherwise!
    UNSAFE_CHEAPEST = {
      t_cost: 1,
      m_cost: 3, # 8 KiB
      p_cost: 1
    }.freeze
  end
end
