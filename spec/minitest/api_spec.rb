# frozen_string_literal: true

require 'spec_helper'

describe 'Argon2APITest' do
  let(:original_password) { 'mypassword' }
  let(:pepper) { 'A secret' }

  it 'can create a password without parameters' do
    argon2 = Argon2::Password.create(original_password)
    verify = Argon2::Password.verify_password(original_password, argon2)

    expect(argon2).to        be_a Argon2::Password
    expect(argon2.m_cost).to eq 16
    expect(argon2.t_cost).to eq 2
    expect(argon2).to        be_matches original_password

    expect(verify).to        be_truthy
  end

  it 'can create a password with parameters' do
    argon2 = Argon2::Password.create(original_password, t_cost: 4, m_cost: 12)
    verify = Argon2::Password.verify_password(original_password, argon2)

    expect(argon2).to        be_a Argon2::Password
    expect(argon2.m_cost).to eq 12
    expect(argon2.t_cost).to eq 4
    expect(argon2).to        be_matches original_password

    expect(verify).to        be_truthy
  end

  it 'can create a password with a secret' do
    argon2 = Argon2::Password.create(original_password, secret: pepper)
    verify = Argon2::Password.verify_password(original_password, argon2, pepper)

    expect(argon2).to be_a Argon2::Password
    expect(argon2).to be_matches original_password, pepper

    expect(verify).to be_truthy
  end

  # The test_hash test is no longer relevant, as you can no longer create an
  # empty Argon2::Password instance.

  it 'can create a valid hash' do
    argon2 = Argon2::Password.create(original_password)

    expect(Argon2::Password.valid_hash?(argon2)).to be_truthy
  end
end
