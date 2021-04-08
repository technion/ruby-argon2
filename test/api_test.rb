# frozen_string_literal: true

require 'test_helper'

module Argon2
  # Simple stub to facilitate testing these variables (stub now unnecessary)
  # class Password
  #   attr_accessor :t_cost, :m_cost, :secret
  # end
end

class Argon2APITest < Minitest::Test
  def test_create_default
    assert pass = Argon2::Password.create('mypassword')
    assert_instance_of Argon2::Password, pass
    assert_equal 16, pass.m_cost
    assert_equal 2, pass.t_cost
    # assert_nil pass.secret # Secret is not persisted on the Argon2::Password
  end

  def test_create_args
    assert pass = Argon2::Password.create('mypassword', t_cost: 4, m_cost: 12)
    assert_instance_of Argon2::Password, pass
    assert_equal 12, pass.m_cost
    assert_equal 4, pass.t_cost
    # assert_nil pass.secret # Secret is not persisted on the Argon2::Password
  end

  # For usage of the secret param, see key_test.rb
  def test_secret
    assert pass = Argon2::Password.create('mypassword', secret: "A secret")
    skip("The secret isn't kept on the Argon2::Password instance")
    assert_equal pass.secret, "A secret"
  end

  def test_hash
    assert Argon2::Password.create('mypassword')
  end

  def test_valid_hash
    secure_pass = Argon2::Password.create('A secret')
    assert Argon2::Password.valid_hash?(secure_pass)
  end

  ###############
  ## New Tests ##
  ###############
  ORIGINAL_PASSWORD = 'mypassword'
  PEPPER = 'A secret'

  def test_create_password_without_parameters
    assert argon2 = Argon2::Password.create(ORIGINAL_PASSWORD)

    assert argon2.is_a?(Argon2::Password)
    assert_equal argon2.m_cost, 16
    assert_equal argon2.t_cost, 2
    assert argon2.matches?(ORIGINAL_PASSWORD)
    assert Argon2::Password.verify_password(ORIGINAL_PASSWORD, argon2)
  end

  def test_create_password_with_parameters
    assert argon2 = Argon2::Password.create(ORIGINAL_PASSWORD, t_cost: 4, m_cost: 12)

    assert argon2.is_a?(Argon2::Password)
    assert_equal argon2.m_cost, 12
    assert_equal argon2.t_cost, 4
    assert argon2.matches?(ORIGINAL_PASSWORD)
    assert Argon2::Password.verify_password(ORIGINAL_PASSWORD, argon2)
  end

  def test_create_password_with_secret
    assert argon2 = Argon2::Password.create(ORIGINAL_PASSWORD, secret: PEPPER)

    assert argon2.is_a?(Argon2::Password)
    assert_equal argon2.m_cost, 16
    assert_equal argon2.t_cost, 2
    assert argon2.matches?(ORIGINAL_PASSWORD, PEPPER)
    assert Argon2::Password.verify_password(ORIGINAL_PASSWORD, argon2, PEPPER)
  end
end
