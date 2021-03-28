# frozen_string_literal: true

require 'spec_helper'

describe 'Errors' do
  describe Argon2::Error do
    subject { described_class }

    it { is_expected.to be < StandardError }
  end

  describe Argon2::Errors::InvalidHash do
    subject { described_class }

    it { is_expected.to be < Argon2::Error }
  end

  describe Argon2::Errors::InvalidVersion do
    subject { described_class }

    it { is_expected.to be < Argon2::Errors::InvalidHash }
  end

  describe Argon2::Errors::InvalidCost do
    subject { described_class }

    it { is_expected.to be < Argon2::Errors::InvalidHash }
  end

  describe Argon2::Errors::InvalidTCost do
    subject { described_class }

    it { is_expected.to be < Argon2::Errors::InvalidCost }
  end

  describe Argon2::Errors::InvalidMCost do
    subject { described_class }

    it { is_expected.to be < Argon2::Errors::InvalidCost }
  end

  describe Argon2::Errors::InvalidPCost do
    subject { described_class }

    it { is_expected.to be < Argon2::Errors::InvalidCost }
  end

  describe Argon2::Errors::InvalidPassword do
    subject { described_class }

    it { is_expected.to be < Argon2::Error }
  end

  describe Argon2::Errors::InvalidSaltSize do
    subject { described_class }

    it { is_expected.to be < Argon2::Error }
  end

  describe Argon2::Errors::InvalidOutputLength do
    subject { described_class }

    it { is_expected.to be < Argon2::Error }
  end

  describe Argon2::Errors::ExtError do
    subject { described_class }

    it { is_expected.to be < Argon2::Error }
  end
end
