# frozen_string_literal: true

require 'test_helper'

class PasswordEqualsTest < Minitest::Test
  # TODO: Randomly generate a new password with Faker
  # SECRET = Faker::Internet.unique.password
  SECRET = 'mysecretpassword'
  PASS = Argon2::Password.create(SECRET)
  DIGEST = PASS.to_s

  def test_refuses_string
    assert_raises ArgumentError do
      PASS == SECRET
    end

    assert_raises ArgumentError do
      PASS == DIGEST
    end
  end

  def test_accepts_argon2_password
    assert_equal Argon2::Password.new(DIGEST), PASS
  end
end
