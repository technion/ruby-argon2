# frozen_string_literal: true

require 'test_helper'

# The Github action sets this to 100, the value used to find the NULL hash bug.
TIMES = (ENV['TEST_CHECKS'] || 1).to_i

# This was supposed to use Rubycheck, however the current version doesn't run
# These property tests identified the NULL hash bug
class Argon2PropertyTest < Minitest::Test
  def test_success
    hashlist = {}
    TIMES.times do
      word = Argon2::Engine.saltgen
      assert hashlist[word] = Argon2::Password.create(word),
             word.unpack('H*').join
    end
    hashlist.each do |word, hash|
      assert Argon2::Password.verify_password(word, hash),
             word.unpack('H*').join
    end
  end

  def test_fail
    hashlist = {}
    TIMES.times do
      word = Argon2::Engine.saltgen
      assert hashlist[word] = Argon2::Password.create(word),
             word.unpack('H*').join
    end
    hashlist.each do |word, hash|
      wrongword = Argon2::Engine.saltgen
      refute Argon2::Password.verify_password(wrongword, hash),
             word.unpack('H*').join
    end
  end
end
