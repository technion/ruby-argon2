# frozen_string_literal: true

require 'test_helper'

class LowLevelArgon2Test < Minitest::Test
  KEY = "a magic key"
  PASS = "random password"
  def test_key_hash
    # Default hash
    assert basehash = Argon2::Password.create(PASS, t_cost: 2, m_cost: 16)
    # Keyed hash
    assert keyhash = Argon2::Password.create(PASS, t_cost: 2, m_cost: 16, secret: KEY)

    # Isn't this test somewhat pointless? Each password will have a new salt,
    # so they can never match anyway.
    refute_equal basehash, keyhash

    # Demonstrate problem:
    assert salthash = Argon2::Password.create(PASS, t_cost: 2, m_cost: 16)
    refute_equal basehash, salthash
    # Prove that it's not just the `==` being broken:
    assert_equal basehash, basehash
    assert_equal salthash, salthash
    assert_equal keyhash,  keyhash

    # The keyed hash - without the key
    refute Argon2::Password.verify_password(PASS, keyhash)
    # With key
    assert Argon2::Password.verify_password(PASS, keyhash, KEY)
  end

  # So apparently the salt that's in the digest is actually different from the
  # salt used to generate the argon2 hash.
  #
  # To demonstrate:
  #
  # salt = Argon2::Engine.saltgen
  # argon2 = Argon2::Password.create('anysecret', salt_do_not_supply: salt)
  # salt == argon2.salt
  # => false
  # salt.length
  # => 16
  # argon2.salt.length
  # => 22
  # salt
  # => "\xCA\xFD\xED\x18\x10\xD1!R\xF2\xA9\f4\xD2\x966\x9D"
  # argon2.salt
  # => "yv3tGBDRIVLyqQw00pY2nQ"
  #
  # This combined with the fact that you're not supposed to supply the salt in
  # the first place, makes me wonder if we should just hard deprecate passing in
  # the salt at all. In its current state, it provides literally no value and
  # allows developers to shoot themselves in the foot.
  #
  # This test might be blown away soon anyway, temp disable abc cop.
  # rubocop:disable Metrics/AbcSize
  def test_key_hash_with_same_salts
    skip('The salt going in is not the same as the salt in the digest')
    assert basehash = Argon2::Password.create(PASS)
    assert salthash = Argon2::Password.create(PASS, salt_do_not_supply: basehash.salt)
    assert keyhash  = Argon2::Password.create(PASS, salt_do_not_supply: basehash.salt, secret: KEY)

    # Prove that you can create an identical copy
    assert_equal basehash, salthash
    # Prove that both hashes without peppers do not equal hash with pepper
    refute_equal basehash, keyhash
    refute_equal salthash, keyhash

    # Test unkeyed hashes
    assert Argon2::Password.verify_password(PASS, basehash)
    assert Argon2::Password.verify_password(PASS, salthash)

    refute Argon2::Password.verify_password(PASS, basehash, KEY)
    refute Argon2::Password.verify_password(PASS, salthash, KEY)

    # Test keyed hash
    refute Argon2::Password.verify_password(PASS, keyhash)

    assert Argon2::Password.verify_password(PASS, keyhash, KEY)
  end
  # rubocop:enable Metrics/AbcSize
end
