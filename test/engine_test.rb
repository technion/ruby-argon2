# frozen_string_literal: true

require 'test_helper'

class EngineTest < Minitest::Test
  def test_saltgen
    generate = []
    assert(10.times { generate << Argon2::Engine.saltgen })
    duplicates = generate.select { |e| generate.count(e) > 1 }
    assert_equal duplicates.length, 0
    wrong_length = generate.reject do |e|
      e.length == Argon2::Constants::SALT_LEN
    end
    assert_equal wrong_length.size, 0
  end
end
