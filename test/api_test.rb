# frozen_string_literal: true

require 'test_helper'

class Argon2APITest < Minitest::Test
  PASS = 'mypassword'
  SECRET = 'A secret'

  def test_create_default
    assert pass = Argon2::Password.create(PASS)
    assert hash = Argon2::HashFormat.new(pass)
    assert_equal (2**16), hash.m_cost
    assert_equal 2, hash.t_cost
    assert_equal 1, hash.p_cost
    assert Argon2::Password.verify_password(PASS, pass)
  end

  def test_create_args
    assert pass = Argon2::Password.create(PASS, t_cost: 4, m_cost: 12, p_cost: 4)
    assert hash = Argon2::HashFormat.new(pass)
    assert_equal (2**12), hash.m_cost
    assert_equal 4, hash.t_cost
    assert_equal 4, hash.p_cost
    assert Argon2::Password.verify_password(PASS, pass)
  end

  def test_secret
    assert pass = Argon2::Password.create(PASS, secret: SECRET)
    assert Argon2::Password.verify_password(PASS, pass, SECRET)
  end

  # Duplicates test_create_default with new format, remove?
  def test_hash
    assert pass = Argon2::Password.create(PASS)
    assert Argon2::Password.valid_hash?(pass)
  end

  # Duplicates test_create_default with new format, remove?
  def test_valid_hash
    secure_pass = Argon2::Password.create(SECRET)
    assert Argon2::Password.valid_hash?(secure_pass)
  end
end
