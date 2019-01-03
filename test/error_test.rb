require 'test_helper'

class Argon2ErrorTest < Minitest::Test
  def test_ffi_fail
    assert_raises Argon2::ArgonHashFail do
      Argon2::Engine.hash_argon2i("password", "somesalt\0\0\0\0\0\0\0\0", 2, 1)
    end
  end

  def test_memory_too_small
    assert_raises Argon2::ArgonHashFail do
      Argon2::Engine.hash_argon2id_encode("password",
          "somesalt\0\0\0\0\0\0\0\0", 2, 1, nil)
    end
  end

  def test_salt_size
    assert_raises Argon2::ArgonHashFail do
      Argon2::Engine.hash_argon2id_encode("password", "somesalt", 2, 16, nil)
    end
  end

  def test_passwd_null
    assert_raises Argon2::ArgonHashFail do
      Argon2::Engine.hash_argon2id_encode(nil, "somesalt\0\0\0\0\0\0\0\0", 2,
          16, nil)
    end
  end
end
