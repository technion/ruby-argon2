# frozen_string_literal: true

require 'spec_helper'

describe 'Argon2ErrorTest' do
  it 'ffi fail' do
    expect{
      Argon2::Engine.hash_argon2i("password", "somesalt\0\0\0\0\0\0\0\0", 2, 1)
    }.to raise_error Argon2::Error
  end

  it 'memory too small' do
    expect{
      Argon2::Engine.hash_argon2id_encode("password",
                                          "somesalt\0\0\0\0\0\0\0\0", 2, 1, nil)
    }.to raise_error Argon2::Error
  end

  it 'salt size' do
    expect{
      Argon2::Engine.hash_argon2id_encode("password", "somesalt", 2, 16, nil)
    }.to raise_error Argon2::Error
  end

  it 'password null' do
    expect{
      Argon2::Engine.hash_argon2id_encode(nil, "somesalt\0\0\0\0\0\0\0\0", 2,
                                          16, nil)
    }.to raise_error Argon2::Error
  end
end
