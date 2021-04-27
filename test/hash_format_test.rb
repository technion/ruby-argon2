# frozen_string_literal: true

require 'test_helper'

class Argon2HashFormatTest < Minitest::Test
  PASSWORD = 'My secret password'
  OPTIONS = {
    t_cost: 4,
    m_cost: 12,
    p_cost: 3
  }.freeze

  TEMP = Argon2::Password.new(OPTIONS)
  DIGEST = TEMP.create(PASSWORD)

  def test_hash_format_variant
    assert argon2 = Argon2::HashFormat.new(DIGEST)

    assert_equal 'argon2id', argon2.variant
  end

  def test_hash_format_version
    assert argon2 = Argon2::HashFormat.new(DIGEST)

    assert_equal 19, argon2.version
  end

  def test_hash_format_t_cost
    assert argon2 = Argon2::HashFormat.new(DIGEST)

    assert_equal OPTIONS[:t_cost], argon2.t_cost
  end

  def test_hash_format_m_cost
    assert argon2 = Argon2::HashFormat.new(DIGEST)

    assert_equal (2**OPTIONS[:m_cost]), argon2.m_cost
  end

  def test_hash_format_p_cost
    assert argon2 = Argon2::HashFormat.new(DIGEST)

    assert_equal OPTIONS[:p_cost], argon2.p_cost
  end
end
