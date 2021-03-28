# frozen_string_literal: true

require 'test_helper'
# frozen_string_literal: true

class Legacy < Minitest::Test
  HASH_1_0 = "$argon2i$m=65536,t=1,p=1$c29tZXNhbHQAAAAAAAAAAA$+r0d29hqEB0yasKr55ZgICsQGSkl0v0kgwhd+U3wyRo"
  HASH_1_1 = "$argon2i$v=19$m=65536,t=1,p=1$c29tZXNhbHQAAAAAAAAAAA$+r0d29hqEB0yasKr55ZgICsQGSkl0v0kgwhd+U3wyRo"
  HASH_0 = "$argon2i$v=16$m=256,t=2,p=1$c29tZXNhbHQ$/U3YPXYsSb3q9XxHvc0MLxur+GP960kN9j7emXX8zwY"
  def test_legacy_hashes
    # These are the hash formats for 1.0 and 1.1 of this gem.
    assert Argon2::Password.verify_password(PASS, HASH_1_0)
    assert Argon2::Password.verify_password(PASS, HASH_1_1)
    assert Argon2::Password.verify_password(PASS, HASH_0)
  end

  def test_valid_hash_legacy_hashes
    # These are the hash formats for 1.0 and 1.1 of this gem.
    assert Argon2::Password.valid_hash?(PASS, HASH_1_0)
    assert Argon2::Password.valid_hash?(PASS, HASH_1_1)
    assert Argon2::Password.valid_hash?(PASS, HASH_0)
  end
end
