# frozen_string_literal: true

require 'test_helper'

class LowLevelArgon2Test < Minitest::Test
  KEY = "a magic key"
  PASS = "random password"
  def test_key_hash
    # Default hash
    argon = Argon2::Password.new(t_cost: 2, m_cost: 16)
    assert basehash = argon.create(PASS)
    # Keyed hash
    argon = Argon2::Password.new(t_cost: 2, m_cost: 16, secret: KEY)
    assert keyhash = argon.create(PASS)
    refute_equal basehash, keyhash
    # The keyed hash - without the key
    refute Argon2::Password.verify_password(PASS, keyhash)
    # With key
    assert Argon2::Password.verify_password(PASS, keyhash, KEY)
  end
end
