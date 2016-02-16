require 'test_helper'

class UnicodeTest < Minitest::Test
  def test_utf16
    # A string found on Google which encodes with a NULL byte
    unstr = "Σὲ γνωρίζω ἀπὸ τὴν κό".encode("utf-16le")
    assert hash = Argon2::Password.create(unstr)
    assert Argon2::Password.verify_password(unstr, hash)
  end

  def test_null_byte
    rawstr = "String has a\0NULL in it"
    hash = Argon2::Password.create(rawstr)
    assert Argon2::Password.verify_password(rawstr, hash)
    # Asserts that no NULL byte truncation occurs
    refute Argon2::Password.verify_password("String has a", hash),
      "Does not NULL truncate"
  end
end
