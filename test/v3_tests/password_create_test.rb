# frozen_string_literal: true

require 'test_helper'

class PasswordCreateTest < Minitest::Test
  # TODO: Randomly generate a new password with Faker
  # SECRET = Faker::Internet.unique.password
  SECRET = 'mysecretpassword'
  # Time cost constants
  DEFAULT_T_COST = Argon2::Password::DEFAULT_T_COST
  MIN_T_COST     = Argon2::Password::MIN_T_COST
  MAX_T_COST     = Argon2::Password::MAX_T_COST
  # Memory cost constants
  DEFAULT_M_COST = Argon2::Password::DEFAULT_M_COST
  MIN_M_COST     = Argon2::Password::MIN_M_COST
  MAX_M_COST     = Argon2::Password::MAX_M_COST

  def test_default_t_cost
    assert pass = Argon2::Password.create(SECRET, t_cost: DEFAULT_T_COST)

    assert_instance_of Argon2::Password, pass
    assert_equal DEFAULT_T_COST, pass.t_cost
  end

  def test_min_t_cost
    assert pass = Argon2::Password.create(SECRET, t_cost: MIN_T_COST)

    assert_instance_of Argon2::Password, pass
    assert_equal MIN_T_COST, pass.t_cost

    # Ensure that going below the minimum results in an InvalidTCost error
    assert_raises Argon2::Errors::InvalidTCost do
      Argon2::Password.create(SECRET, t_cost: MIN_T_COST - 1)
    end
  end

  # FIXME: This is a really slow test due to _actually running_ the max cost. Is
  #        there a way to test that the max cost works without incurring this
  #        test suite speed penalty?
  def test_max_t_cost
    # assert pass = Argon2::Password.create(SECRET, t_cost: MAX_T_COST)

    # assert_instance_of Argon2::Password, pass
    # assert_equal MAX_T_COST, pass.t_cost

    # Ensure that going above the maximum results in an InvalidTCost error
    assert_raises Argon2::Errors::InvalidTCost do
      Argon2::Password.create(SECRET, t_cost: MAX_T_COST + 1)
    end
  end

  def test_default_m_cost
    assert pass = Argon2::Password.create(SECRET, m_cost: DEFAULT_M_COST)

    assert_instance_of Argon2::Password, pass
    assert_equal DEFAULT_M_COST, pass.m_cost
  end

  def test_min_m_cost
    assert pass = Argon2::Password.create(SECRET, m_cost: MIN_M_COST)

    assert_instance_of Argon2::Password, pass
    assert_equal MIN_M_COST, pass.m_cost

    # Ensure that going below the minimum results in an InvalidMCost error
    assert_raises Argon2::Errors::InvalidMCost do
      Argon2::Password.create(SECRET, m_cost: MIN_M_COST - 1)
    end
  end

  # FIXME: When testing maximum memory cost, fails due to:
  #        Argon2::Errors::ExtError: ARGON2_MEMORY_ALLOCATION_ERROR
  def test_max_m_cost
    # assert pass = Argon2::Password.create(SECRET, m_cost: MAX_M_COST)

    # assert_instance_of Argon2::Password, pass
    # assert_equal MAX_M_COST, pass.m_cost

    # Ensure that going above the maximum results in an InvalidMCost error
    assert_raises Argon2::Errors::InvalidMCost do
      Argon2::Password.create(SECRET, m_cost: MAX_M_COST + 1)
    end
  end
end
