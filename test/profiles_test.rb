# frozen_string_literal: true

require 'test_helper'

class ProfilesTest < Minitest::Test
  def test_hash_access
    assert_equal Argon2::Profiles::RFC_9106_LOW_MEMORY, Argon2::Profiles[:RFC_9106_LOW_MEMORY]
  end

  def test_to_a
    # rubocop:disable Naming/VariableNumber
    assert_equal %i[
      pre_rfc_9106
      rfc_9106_high_memory
      rfc_9106_low_memory
      unsafe_cheapest
    ], Argon2::Profiles.to_a.sort
    # rubocop:enable Naming/VariableNumber
  end

  def test_to_h
    hash = Argon2::Profiles.to_h
    assert_equal Argon2::Profiles::RFC_9106_HIGH_MEMORY, hash[:rfc_9106_high_memory]
  end

  def test_structure
    Argon2::Profiles.to_h.values do |profile|
      assert_equal %i[t_cost m_cost p_cost], profile.keys
      assert(profile.values.all? { |v| v.instance_of?(Integer) })
    end
  end
end
