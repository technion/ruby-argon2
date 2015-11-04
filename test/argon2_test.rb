require 'test_helper'

class Argon2Test < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Argon2::VERSION
  end

  def test_vector
    assert_equal Argon2.hash_argon2i("password",  "somesalt\0\0\0\0\0\0\0\0"), '894af4ff2e2d26f3ce15f77a7e1c25db45b4e20439e9961772ba199caddb001e'
  end
end
