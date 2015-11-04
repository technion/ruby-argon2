require 'test_helper'

class Argon2Test < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Argon2::VERSION
  end

  def test_vector
    assert_equal Argon2.hash_argon2i("password",  "somesalt\0\0\0\0\0\0\0\0"), '894af4ff2e2d26f3ce15f77a7e1c25db45b4e20439e9961772ba199caddb001e'
  end

  def test_hash
    assert_equal Argon2.hash_argon2i_encode("password",  "somesalt\0\0\0\0\0\0\0\0"), '$argon2i$m=65536,t=2,p=4$c29tZXNhbHQAAAAAAAAAAA$JGFyZ29uMmkkbT02NTUzNix0PTIscD00JGMyOXRaWE4'
  end
end
