require 'test_helper'

module Argon2
  #Simple stub to facilitate testing these variables
  class Password
    attr_accessor :t_cost, :m_cost
  end
end

class Argon2APITest < Minitest::Test
  def test_create_default
    assert pass = Argon2::Password.new
    assert_instance_of Argon2::Password, pass
    assert_equal 16, pass.m_cost
    assert_equal 2, pass.t_cost
  end

  def test_create_args
    assert pass = Argon2::Password.new(t_cost: 4, m_cost: 12)
    assert_instance_of Argon2::Password, pass
    assert_equal 12, pass.m_cost
    assert_equal 4, pass.t_cost
  end

  def test_hash
    assert pass = Argon2::Password.new
    assert pass.hash('mypassword')
  end
end
