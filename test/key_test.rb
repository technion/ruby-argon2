require 'test_helper'

class LowLevelArgon2Test < Minitest::Test
  def test_key_hash
    # Default hash
    argon = Argon2::Password.new(t_cost: 2, m_cost: 16)
    assert basehash = argon.hash("A password")
    # Keyed hash
    argon = Argon2::Password.new(t_cost: 2, m_cost: 16, secret: "A Key")
    assert keyhash = argon.hash("A password")
    refute_equal basehash, keyhash
    # The keyed hash - without the key
    refute Argon2::Password.verify_password("A password", keyhash)
  end
end
