# frozen_string_literal: true

require 'test_helper'

class PasswordNewTest < Minitest::Test
  # TODO: Randomly generate a new password with Faker
  # SECRET = Faker::Internet.unique.password
  SECRET = 'mysecretpassword'
  PASS = Argon2::Password.create(SECRET)
  DIGEST = PASS.to_s
  # What would be appropriate bad digest(s) to test? Using a bcrypt hash for now
  BAD_DIGEST = '$2a$05$CCCCCCCCCCCCCCCCCCCCC.E5YPO9kmyuRGyh0XouQYb4YMJKvyOeW'

  def test_accepts_valid_string
    assert argon2 = Argon2::Password.new(DIGEST)
    assert argon2.is_a?(Argon2::Password)

    assert_equal argon2, PASS
    assert_equal argon2.to_s, DIGEST

    assert argon2.matches?(SECRET)
    assert Argon2::Password.verify_password(SECRET, argon2)
    assert Argon2::Password.verify_password(argon2, DIGEST)
  end

  def test_rejects_invalid_string
    assert_raises Argon2::Errors::InvalidHash do
      Argon2::Password.new(BAD_DIGEST)
    end
  end

  def test_accepts_argon2_password
    assert argon2 = Argon2::Password.new(PASS)
    assert argon2.is_a?(Argon2::Password)

    assert_equal argon2, PASS
    assert_equal argon2.to_s, DIGEST

    assert argon2.matches?(SECRET)
    assert Argon2::Password.verify_password(SECRET, argon2)
    assert Argon2::Password.verify_password(argon2, DIGEST)
  end
end
