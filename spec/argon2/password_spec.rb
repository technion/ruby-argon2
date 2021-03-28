# frozen_string_literal: true

require 'spec_helper'

describe Argon2::Password do
  let(:original_password) { Faker::Internet.password }

  describe 'initialize' do
    let(:digest) { Argon2::Password.create(original_password) }

    it 'accepts a valid Argon2 String' do
      expect(described_class.new(digest.to_s)).to be_a described_class
    end

    it 'accepts a valid Argon2::Password' do
      expect(described_class.new(digest)).to be_a described_class
    end
  end
end
