require 'test_helper'

# Vectors in this suite taken from test.c in reference

class LowLevelArgon2Test < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Argon2::VERSION
  end

  def test_ffi_vector
    assert_equal Argon2::Engine.hash_argon2i(
        "password", "somesalt\0\0\0\0\0\0\0\0", 2, 16),
        '1c7eeef9e0e969b3024722fc864a1ca9f6ca20da73f9bf3f1731881beae2039e'

    assert_equal Argon2::Engine.hash_argon2i(
        "password", "somesalt\0\0\0\0\0\0\0\0", 2, 18),
        '5c6dfd2712110cf88f1426059b01d87f8210d5368da0e7ee68586e9d4af4954b'

    assert_equal Argon2::Engine.hash_argon2i(
        "password", "somesalt\0\0\0\0\0\0\0\0", 2, 8),
        'dfebf9d4eadd6859f4cc6a9bb20043fd9da7e1e36bdacdbb05ca569f463269f8'

    assert_equal Argon2::Engine.hash_argon2i(
        "password", "somesalt\0\0\0\0\0\0\0\0", 1, 16),
        'fabd1ddbd86a101d326ac2abe79660202b10192925d2fd2483085df94df0c91a'

    assert_equal Argon2::Engine.hash_argon2i(
        "password", "somesalt\0\0\0\0\0\0\0\0", 4, 16),
        'b3b4cb3d6e2c1cb1e7bffdb966ab3ceafae701d6b7789c3f1e6c6b22d82d99d5'

    assert_equal Argon2::Engine.hash_argon2i(
        "differentpassword", "somesalt\0\0\0\0\0\0\0\0", 2, 16),
        'b2db9d7c0d1288951aec4b6e1cd3835ea29a7da2ac13e6f48554a26b127146f9'

    assert_equal Argon2::Engine.hash_argon2i(
        "password", "diffsalt\0\0\0\0\0\0\0\0", 2, 16),
        'bb6686865f2c1093f70f543c9535f807d5b42d5dc6d71f14a4a7a291913e05e0'
  end

  def test_encoded_hash
    assert_equal Argon2::Engine.hash_argon2i_encode(
        "password", "somesalt\0\0\0\0\0\0\0\0", 2, 16, nil),
        '$argon2i$v=19$m=65536,t=2,p=1$c29tZXNhbHQAAAAAAAAAAA$HH7u+eDpabMCRyL8hkocqfbKINpz+b8/FzGIG+riA54'

    assert_equal Argon2::Engine.hash_argon2i_encode(
        "password", "somesalt\0\0\0\0\0\0\0\0", 2, 8, nil),
        '$argon2i$v=19$m=256,t=2,p=1$c29tZXNhbHQAAAAAAAAAAA$3+v51OrdaFn0zGqbsgBD/Z2n4eNr2s27BcpWn0Yyafg'

    assert_equal Argon2::Engine.hash_argon2i_encode(
        "password", "somesalt\0\0\0\0\0\0\0\0", 1, 16, nil),
        '$argon2i$v=19$m=65536,t=1,p=1$c29tZXNhbHQAAAAAAAAAAA$+r0d29hqEB0yasKr55ZgICsQGSkl0v0kgwhd+U3wyRo'

    assert_equal Argon2::Engine.hash_argon2i_encode(
        "differentpassword", "somesalt\0\0\0\0\0\0\0\0", 2, 16, nil),
        '$argon2i$v=19$m=65536,t=2,p=1$c29tZXNhbHQAAAAAAAAAAA$studfA0SiJUa7EtuHNODXqKafaKsE+b0hVSiaxJxRvk'

    assert_equal Argon2::Engine.hash_argon2i_encode(
        "password", "diffsalt\0\0\0\0\0\0\0\0", 2, 16, nil),
        '$argon2i$v=19$m=65536,t=2,p=1$ZGlmZnNhbHQAAAAAAAAAAA$u2aGhl8sEJP3D1Q8lTX4B9W0LV3G1x8UpKeikZE+BeA'
  end

  def test_encode
    assert Argon2::Engine.argon2i_verify("password", "$argon2i$v=19$m=65536,t=1,p=1$c29tZXNhbHQAAAAAAAAAAA$+r0d29hqEB0yasKr55ZgICsQGSkl0v0kgwhd+U3wyRo", nil)
    refute Argon2::Engine.argon2i_verify("notword", "$argon2i$v=19$m=65536,t=1,p=1$c29tZXNhbHQAAAAAAAAAAA$+r0d29hqEB0yasKr55ZgICsQGSkl0v0kgwhd+U3wyRo", nil)
  end
end
