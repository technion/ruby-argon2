require 'test_helper'

class LowLevelArgon2Test < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Argon2::VERSION
  end


  def test_ffi_vector
    #./argon2 password somesalt -t 2 -m 16
    #Hash: 894af4ff2e2d26f3ce15f77a7e1c25db45b4e20439e9961772ba199caddb001e
    assert_equal Argon2::Engine.hash_argon2i(
        "password", "somesalt\0\0\0\0\0\0\0\0", 2, 16), 
        '894af4ff2e2d26f3ce15f77a7e1c25db45b4e20439e9961772ba199caddb001e'

    #./argon2 password somesalt -t 2 -m 20
    #Hash: 58d4d929aeeafa40cc049f032035784fb085e8e0d0c5a51ea067341a93d6d286
    assert_equal Argon2::Engine.hash_argon2i(
        "password", "somesalt\0\0\0\0\0\0\0\0", 2, 20),
        '58d4d929aeeafa40cc049f032035784fb085e8e0d0c5a51ea067341a93d6d286'

    #./argon2 password somesalt -t 2 -m 18
    #Hash: 55292398cce8fc78685e610d004ca9bda5c325a0a2e6285a0de5f816df139aa6
    assert_equal Argon2::Engine.hash_argon2i(
        "password", "somesalt\0\0\0\0\0\0\0\0", 2, 18), 
        '55292398cce8fc78685e610d004ca9bda5c325a0a2e6285a0de5f816df139aa6'

    #./argon2 password somesalt -t 2 -m 8
    #Hash: e346b1e1aa7ca58c9bb862e223ba5604064398d4394e49e90972c6b54cef43ed
    assert_equal Argon2::Engine.hash_argon2i(
        "password", "somesalt\0\0\0\0\0\0\0\0", 2, 8),
        'e346b1e1aa7ca58c9bb862e223ba5604064398d4394e49e90972c6b54cef43ed'

    #./argon2 password somesalt -t 1 -m 16
    #Hash: b49199e4ecb0f6659e6947f945e391c940b17106e1d0b0a9888006c7f87a789b
    assert_equal Argon2::Engine.hash_argon2i(
        "password", "somesalt\0\0\0\0\0\0\0\0", 1, 16),
        'b49199e4ecb0f6659e6947f945e391c940b17106e1d0b0a9888006c7f87a789b'

    #./argon2 password somesalt -t 4 -m 16
    #Hash: 72207b3312d79995fbe7b30664837ae1246f9a98e07eac34835ca3498e705f85
    assert_equal Argon2::Engine.hash_argon2i(
        "password", "somesalt\0\0\0\0\0\0\0\0", 4, 16),
        '72207b3312d79995fbe7b30664837ae1246f9a98e07eac34835ca3498e705f85'

    #./argon2 differentpassword somesalt -t 2 -m 16 -p 1
    #Hash: 8e286f605ed7383987a4aac25a28a04808593b6e17613bc31457146c4f3f4361
    assert_equal Argon2::Engine.hash_argon2i(
        "differentpassword", "somesalt\0\0\0\0\0\0\0\0", 2, 16),
        '8e286f605ed7383987a4aac25a28a04808593b6e17613bc31457146c4f3f4361'

    #./argon2 password diffsalt -t 2 -m 16 -p 1
    #Hash: 8f65b47d902fb2aee5e0b2bdc9041b249fc11f06f35551e0bee52716b41e8311
    assert_equal Argon2::Engine.hash_argon2i(
        "password", "diffsalt\0\0\0\0\0\0\0\0", 2, 16),
        '8f65b47d902fb2aee5e0b2bdc9041b249fc11f06f35551e0bee52716b41e8311'
  end

  def test_encoded_hash
    #./util.rb 894af4ff2e2d26f3ce15f77a7e1c25db45b4e20439e9961772ba199caddb001e
    #iUr0/y4tJvPOFfd6fhwl20W04gQ56ZYXcroZnK3bAB4
    assert_equal Argon2::Engine.hash_argon2i_encode(
        "password", "somesalt\0\0\0\0\0\0\0\0", 2, 16),
        '$argon2i$m=65536,t=2,p=1$c29tZXNhbHQAAAAAAAAAAA$iUr0/y4tJvPOFfd6fhwl20W04gQ56ZYXcroZnK3bAB4'

    #./util.rb 58d4d929aeeafa40cc049f032035784fb085e8e0d0c5a51ea067341a93d6d286
    #WNTZKa7q+kDMBJ8DIDV4T7CF6ODQxaUeoGc0GpPW0oY
    assert_equal Argon2::Engine.hash_argon2i_encode(
        "password", "somesalt\0\0\0\0\0\0\0\0", 2, 20),
        '$argon2i$m=1048576,t=2,p=1$c29tZXNhbHQAAAAAAAAAAA$WNTZKa7q+kDMBJ8DIDV4T7CF6ODQxaUeoGc0GpPW0oY'

    #./util.rb e346b1e1aa7ca58c9bb862e223ba5604064398d4394e49e90972c6b54cef43ed
    #40ax4ap8pYybuGLiI7pWBAZDmNQ5TknpCXLGtUzvQ+0
    assert_equal Argon2::Engine.hash_argon2i_encode(
        "password", "somesalt\0\0\0\0\0\0\0\0", 2, 8),
        '$argon2i$m=256,t=2,p=1$c29tZXNhbHQAAAAAAAAAAA$40ax4ap8pYybuGLiI7pWBAZDmNQ5TknpCXLGtUzvQ+0'

    #./util.rb b49199e4ecb0f6659e6947f945e391c940b17106e1d0b0a9888006c7f87a789b
    #tJGZ5Oyw9mWeaUf5ReORyUCxcQbh0LCpiIAGx/h6eJs
    assert_equal Argon2::Engine.hash_argon2i_encode(
        "password",  "somesalt\0\0\0\0\0\0\0\0", 1, 16), 
        '$argon2i$m=65536,t=1,p=1$c29tZXNhbHQAAAAAAAAAAA$tJGZ5Oyw9mWeaUf5ReORyUCxcQbh0LCpiIAGx/h6eJs'

    #./util.rb 8e286f605ed7383987a4aac25a28a04808593b6e17613bc31457146c4f3f4361
    #jihvYF7XODmHpKrCWiigSAhZO24XYTvDFFcUbE8/Q2E
    assert_equal Argon2::Engine.hash_argon2i_encode(
        "differentpassword",  "somesalt\0\0\0\0\0\0\0\0", 2, 16), 
        '$argon2i$m=65536,t=2,p=1$c29tZXNhbHQAAAAAAAAAAA$jihvYF7XODmHpKrCWiigSAhZO24XYTvDFFcUbE8/Q2E'

    #./util.rb 8f65b47d902fb2aee5e0b2bdc9041b249fc11f06f35551e0bee52716b41e8311
    #j2W0fZAvsq7l4LK9yQQbJJ/BHwbzVVHgvuUnFrQegxE
    assert_equal Argon2::Engine.hash_argon2i_encode(
        "password",  "diffsalt\0\0\0\0\0\0\0\0", 2, 16), 
        '$argon2i$m=65536,t=2,p=1$ZGlmZnNhbHQAAAAAAAAAAA$j2W0fZAvsq7l4LK9yQQbJJ/BHwbzVVHgvuUnFrQegxE'
  end
end

