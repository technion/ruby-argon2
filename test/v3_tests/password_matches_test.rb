# frozen_string_literal: true

require 'test_helper'

class PasswordMatchesTest < Minitest::Test
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
    assert PASS.matches?(SECRET)
    assert OTHER_PASS.matches?(OTHER_SECRET)

    refute PASS.matches?(OTHER_SECRET)
    refute OTHER_PASS.matches?(SECRET)
  end

  def test_accepts_argon2_password
    assert PASS.matches?(PASS)
    assert OTHER_PASS.matches?(OTHER_PASS)

    refute PASS.matches?(OTHER_PASS)
    refute OTHER_PASS.matches?(PASS)
  end
end
