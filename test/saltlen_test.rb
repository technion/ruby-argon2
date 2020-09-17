# frozen_string_literal: true

require 'test_helper'

class SaltlenTest < Minitest::Test
  # Tests relevant to issue #14
  def test_longsalt
    # A test for verifying existing hashes with diffferent salt lengths
    assert Argon2::Password.verify_password("password",
                                            "$argon2i$v=19$m=65536,t=2,p=1$VG9vTG9uZ1NhbGVMZW5ndGg$mYleBHsG6N0+H4JGJ0xXoIRO6rWNZwN/eQQQ8eHIDmk")
  end

  def test_shortsalt
    # Asserts that no NULL byte truncation occurs
    assert Argon2::Password.verify_password("password",
                                            "$argon2i$v=19$m=65536,t=2,p=1$VG9vU2hvcnRTYWxlTGVu$i59ELgAm5G6J+9+oZwO+kkV48tJyocNh6bHdkj9J5lk")
  end
end
