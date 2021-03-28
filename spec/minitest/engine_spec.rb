# frozen_string_literal: true

require 'spec_helper'

describe 'EngineTest' do
  it 'generates 10 unique salts' do
    salts = []
    # Generate 10 salts...
    10.times do
      salts << Argon2::Engine.saltgen
    end
    # Check for bad salts...
    duplicate_salts = salts.select{ |salt| salts.count(salt) > 1 }
    wrong_length_salts =
      salts.reject { |salt| salt.length == Argon2::Constants::SALT_LEN }

    expect(duplicate_salts.size).to    be_zero
    expect(wrong_length_salts.size).to be_zero
  end
end
