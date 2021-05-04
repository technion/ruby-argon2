# frozen_string_literal: true

require 'test_helper'

class Argon2SaltReuseTest < Minitest::Test
  def test_salt_reuse
    assert pass1 = Argon2::Password.create('any password here 1')
    assert pass2 = Argon2::Password.create('any password here 2')

    refute_equal pass1, pass2

    assert salt1 = Argon2::HashFormat.new(pass1).salt
    assert salt2 = Argon2::HashFormat.new(pass2).salt

    refute_equal salt1, salt2
  end
end
