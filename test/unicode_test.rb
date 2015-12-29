require 'test_helper'

class UnicodeTest < Minitest::Test
  def test_null_byte
    # A string found on Google which encodes with a NULL byte
    unstr = "Σὲ γνωρίζω ἀπὸ τὴν κό".encode("utf-16le")
    assert hash = Argon2::Password.hash(unstr)
    assert Argon2::Password.verify_password(unstr, hash)
  end
end
