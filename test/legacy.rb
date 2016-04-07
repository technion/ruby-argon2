require 'test_helper'
# frozen_string_literal: true

class Legacy < Minitest::Test
  HASH_1_0 = "$argon2i$m=65536,t=1,p=1$c29tZXNhbHQAAAAAAAAAAA$+r0d29hqEB0yasKr55ZgICsQGSkl0v0kgwhd+U3wyRo".freeze
  HASH_1_1 = "$argon2i$v=19$m=65536,t=1,p=1$c29tZXNhbHQAAAAAAAAAAA$+r0d29hqEB0yasKr55ZgICsQGSkl0v0kgwhd+U3wyRo".freeze
  def test_legacy_hashes
    # These are the hash formats for 1.0 and 1.1 of this gem.
    assert Argon2::Password.verify_password(PASS, HASH_1_0)
    assert Argon2::Password.verify_password(PASS, HASH_1_1)
  end
end
