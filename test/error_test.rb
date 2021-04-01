# frozen_string_literal: true

require 'test_helper'

class Argon2ErrorTest < Minitest::Test
  def test_ffi_fail
    assert_raises Argon2::Error do
      Argon2::Engine.hash_argon2i("password", "somesalt\0\0\0\0\0\0\0\0", 2, 1)
    end
  end

  def test_memory_too_small
    assert_raises Argon2::Error do
      Argon2::Engine.hash_argon2id_encode("password",
                                          "somesalt\0\0\0\0\0\0\0\0", 2, 1, nil)
    end
  end

  def test_salt_size
    assert_raises Argon2::Error do
      Argon2::Engine.hash_argon2id_encode("password", "somesalt", 2, 16, nil)
    end
  end

  def test_passwd_null
    assert_raises Argon2::Error do
      Argon2::Engine.hash_argon2id_encode(nil, "somesalt\0\0\0\0\0\0\0\0", 2,
                                          16, nil)
    end
  end

  def test_error_inheritance
    assert Argon2::Error                       < StandardError
    assert Argon2::Errors::InvalidHash         < Argon2::Error
    assert Argon2::Errors::InvalidVersion      < Argon2::Errors::InvalidHash
    assert Argon2::Errors::InvalidCost         < Argon2::Errors::InvalidHash
    assert Argon2::Errors::InvalidTCost        < Argon2::Errors::InvalidCost
    assert Argon2::Errors::InvalidMCost        < Argon2::Errors::InvalidCost
    assert Argon2::Errors::InvalidPCost        < Argon2::Errors::InvalidCost
    assert Argon2::Errors::InvalidPassword     < Argon2::Error
    assert Argon2::Errors::InvalidSaltSize     < Argon2::Error
    assert Argon2::Errors::InvalidOutputLength < Argon2::Error
    assert Argon2::Errors::ExtError            < Argon2::Error
  end

  def test_invalid_password_msg
    assert_equal Argon2::Errors::InvalidPassword.new.message,
                 "Invalid password (expected a String)"
  end
end
