# frozen_string_literal: true

require 'test_helper'

class VerifyPasswordTest < Minitest::Test
  # TODO: Randomly generate a new password with Faker
  # SECRET = Faker::Internet.unique.password
  SECRET = 'mysecretpassword'
  PASS = Argon2::Password.create(SECRET)
  DIGEST = PASS.to_s
  # Confirm other values are invalid
  OTHER_SECRET = 'notmysecretpassword'
  OTHER_PASS = Argon2::Password.create(OTHER_SECRET)
  OTHER_DIGEST = OTHER_PASS.to_s

  def test_accepts_string
    assert Argon2::Password.verify_password(SECRET, DIGEST)
    assert Argon2::Password.verify_password(OTHER_SECRET, OTHER_DIGEST)

    refute Argon2::Password.verify_password(SECRET, OTHER_DIGEST)
    refute Argon2::Password.verify_password(OTHER_SECRET, DIGEST)
  end

  def test_accepts_argon2_password
    assert Argon2::Password.verify_password(PASS, DIGEST)
    assert Argon2::Password.verify_password(OTHER_PASS, OTHER_DIGEST)

    refute Argon2::Password.verify_password(PASS, OTHER_DIGEST)
    refute Argon2::Password.verify_password(OTHER_PASS, DIGEST)
  end
end
