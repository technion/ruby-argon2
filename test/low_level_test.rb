# frozen_string_literal: true

require 'test_helper'

# Vectors in this suite taken from test.c in reference

class LowLevelArgon2Test < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Argon2::VERSION
    assert ::Argon2::VERSION.is_a?(String)
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

    assert_equal Argon2::Engine.hash_argon2i(
      "password", "somesaltsomesalt", 2, 16, 16),
                 '85d58a069b81f7606dc772810d00496d'

    assert_equal Argon2::Engine.hash_argon2id(
      "password", "somesaltsomesalt", 2, 16),
                 'fc33b78139231d34b71626bd6245c1d72efa190ad605c3d8166a72adcedfa2c2'
  end

  def test_encoded_hash
    assert_equal Argon2::Engine.hash_argon2id_encode(
      "password", "somesalt\0\0\0\0\0\0\0\0", 2, 16, nil),
                 '$argon2id$v=19$m=65536,t=2,p=1$c29tZXNhbHQAAAAAAAAAAA$syf8TzB9pvMIGtFhvRATHW1nX43iP+FLaaTXnqpyMrY'

    assert_equal Argon2::Engine.hash_argon2id_encode(
      "password", "somesalt\0\0\0\0\0\0\0\0", 2, 8, nil),
                 '$argon2id$v=19$m=256,t=2,p=1$c29tZXNhbHQAAAAAAAAAAA$TCsNUutWgv3lowstIasFJbdiamKiq8qPUdz2wSvQ4rw'

    assert_equal Argon2::Engine.hash_argon2id_encode(
      "password", "somesalt\0\0\0\0\0\0\0\0", 1, 16, nil),
                 '$argon2id$v=19$m=65536,t=1,p=1$c29tZXNhbHQAAAAAAAAAAA$b7sLmBJ4YGj/yOjMnUDWC1dvrtZr7EPdMT6zB9Fq0pk'

    assert_equal Argon2::Engine.hash_argon2id_encode(
      "differentpassword", "somesalt\0\0\0\0\0\0\0\0", 2, 16, nil),
                 '$argon2id$v=19$m=65536,t=2,p=1$c29tZXNhbHQAAAAAAAAAAA$0bDR2fpiZutijzxlxrjLnqnCSmtG1/reR4QNcavfKLk'

    assert_equal Argon2::Engine.hash_argon2id_encode(
      "password", "diffsalt\0\0\0\0\0\0\0\0", 2, 16, nil),
                 '$argon2id$v=19$m=65536,t=2,p=1$ZGlmZnNhbHQAAAAAAAAAAA$vm1qQXZQ+/MgT2Y+Go7XnxtA9dJz3wotjfg0itOgKlY'
  end

  def test_verify
    assert Argon2::Engine.argon2_verify("password", "$argon2i$v=19$m=65536,t=1,p=1$c29tZXNhbHQAAAAAAAAAAA$+r0d29hqEB0yasKr55ZgICsQGSkl0v0kgwhd+U3wyRo", nil)
    refute Argon2::Engine.argon2_verify("notword", "$argon2i$v=19$m=65536,t=1,p=1$c29tZXNhbHQAAAAAAAAAAA$+r0d29hqEB0yasKr55ZgICsQGSkl0v0kgwhd+U3wyRo", nil)
    assert Argon2::Engine.argon2_verify("password", "$argon2id$v=19$m=262144,t=2,p=1$c29tZXNhbHQ$eP4eyR+zqlZX1y5xCFTkw9m5GYx0L5YWwvCFvtlbLow", nil)
    refute Argon2::Engine.argon2_verify("password", "$argon2id$v=19$m=262144,t=2,p=1$c29tZXNhbHQ$eP4eyR+zqlZX1y5xCFTkw9m5GYx0L5YWwvCFvtlbLok", nil)
    assert Argon2::Engine.argon2_verify("password", "$argon2id$v=19$m=65536,t=2,p=1$c29tZXNhbHQ$CTFhFdXPJO1aFaMaO6Mm5c8y7cJHAph8ArZWb2GRPPc", nil)
    refute Argon2::Engine.argon2_verify("notword", "$argon2id$v=19$m=65536,t=2,p=1$c29tZXNhbHQ$CTFhFdXPJO1aFaMaO6Mm5c8y7cJHAph8ArZWb2GRPPc", nil)
    assert Argon2::Engine.argon2_verify("password", "$argon2d$v=19$m=65536,t=2,p=1$YzI5dFpYTmhiSFFBQUFBQUFBQUFBQQ$Jxy74cswY2mq9y+u+iJcJy8EqOp4t/C7DWDzGwGB3IM", nil)
    refute Argon2::Engine.argon2_verify("notword", "$argon2d$v=19$m=65536,t=2,p=1$YzI5dFpYTmhiSFFBQUFBQUFBQUFBQQ$Jxy74cswY2mq9y+u+iJcJy8EqOp4t/C7DWDzGwGB3IM", nil)
  end
end
