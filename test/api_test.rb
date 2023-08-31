# frozen_string_literal: true

require 'test_helper'

module Argon2
  # Simple stub to facilitate testing these variables
  class Password
    attr_accessor :t_cost, :m_cost, :p_cost, :secret
  end
end

class Argon2APITest < Minitest::Test
  def test_create_default
    assert pass = Argon2::Password.new
    assert_instance_of Argon2::Password, pass
    assert_equal 16, pass.m_cost
    assert_equal 3, pass.t_cost
    assert_equal 4, pass.p_cost
    assert_nil pass.secret
  end

  def test_create_args
    assert pass = Argon2::Password.new(t_cost: 4, m_cost: 12, p_cost: 4)
    assert_instance_of Argon2::Password, pass
    assert_equal 12, pass.m_cost
    assert_equal 4, pass.t_cost
    assert_equal 4, pass.p_cost
    assert_nil pass.secret
  end

  def test_create_profile_arg
    assert pass = Argon2::Password.new(profile: :rfc_9106_high_memory)
    assert_instance_of Argon2::Password, pass
    assert_equal 21, pass.m_cost
    assert_equal 1, pass.t_cost
    assert_equal 4, pass.p_cost
    assert_nil pass.secret
  end

  def test_secret
    assert pass = Argon2::Password.new(secret: "A secret")
    assert_equal pass.secret, "A secret"
  end

  def test_hash
    assert pass = Argon2::Password.new
    assert pass.create('mypassword')
  end

  def test_valid_hash
    secure_pass = Argon2::Password.create('A secret')
    assert Argon2::Password.valid_hash?(secure_pass)
  end
end
