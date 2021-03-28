# frozen_string_literal: true

require 'spec_helper'

describe 'LowLevelArgon2Test' do
  let(:key) { 'a magic key' }
  let(:pass) { 'random password' }

  it 'key hash' do
    # Default hash
    basehash = Argon2::Password.create(pass, t_cost: 2, m_cost: 16)
    # Keyed hash
    keyhash = Argon2::Password.create(pass, t_cost: 2, m_cost: 16, secret: key)

    # Isn't this test somewhat pointless? Each password will have a new salt, so
    # they can never match anyway.
    expect(basehash).not_to eq keyhash

    # Demonstrate problem:
    salthash = Argon2::Password.create(pass, t_cost: 2, m_cost: 16)
    expect(basehash).not_to eq salthash
    # Prove that it's not just the `==` being broken:
    expect(basehash).to eq basehash
    expect(salthash).to eq salthash
    expect(keyhash).to  eq keyhash

    # The keyed hash - without the key
    expect(Argon2::Password.verify_password(pass, keyhash)).to be_falsey
    # With key
    expect(Argon2::Password.verify_password(pass, keyhash, key)).to be_truthy
  end
end
