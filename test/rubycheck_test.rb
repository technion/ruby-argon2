require 'test_helper'

# This was supposed to use Rubycheck, however the current version doesn't run
# These property tests identified the NULL hash bug
class Argon2APITest < Minitest::Test
  def test_success
    hashlist = {}
    100.times do
      word = Argon2::Engine.saltgen
      word.delete! "\x0"
      assert hashlist[word] = Argon2::Password.hash(word),
          word.unpack('H*').join
    end
    hashlist.each do |word, hash|
      assert Argon2::Password.verify_password(word, hash),
          word.unpack('H*').join
    end
  end

  def test_fail
    hashlist = {}
    100.times do
      word = Argon2::Engine.saltgen
      word.delete! "\x0"
      assert hashlist[word] = Argon2::Password.hash(word),
        word.unpack('H*').join
    end
    hashlist.each do |word, hash|
      wrongword = Argon2::Engine.saltgen
      refute Argon2::Password.verify_password(wrongword, hash),
        word.unpack('H*').join
    end
  end
end
