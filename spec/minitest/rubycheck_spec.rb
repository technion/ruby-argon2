# frozen_string_literal: true

require 'spec_helper'

# This was supposed to use Rubycheck, however the current version doesn't run
# These property tests identified the NULL hash bug
describe 'Argon2PropertyTest' do
  let(:run_count) { (ENV['TEST_CHECKS'] || 100).to_i }

  it 'test success' do
    hashlist = {}

    run_count.times do
      word = Argon2::Engine.saltgen
      hashlist[word] = Argon2::Password.create(word)
    end

    hashlist.each do |word, hash|
      expect(
        Argon2::Password.verify_password(word, hash)
      ).to be_truthy
    end
  end

  it 'test fail' do
    hashlist = {}

    run_count.times do
      word = Argon2::Engine.saltgen
      hashlist[word] = Argon2::Password.create(word)
    end

    hashlist.each do |word, hash|
      wrongword = Argon2::Engine.saltgen
      expect(
        Argon2::Password.verify_password(wrongword, hash)
      ).to be_falsey
    end
  end
end
