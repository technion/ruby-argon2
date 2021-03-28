# frozen_string_literal: true

require 'spec_helper'

describe 'SaltlenTest' do
  it 'long salt' do
    expect(
      Argon2::Password.verify_password("password", "$argon2i$v=19$m=65536,t=2,p=1$VG9vTG9uZ1NhbGVMZW5ndGg$mYleBHsG6N0+H4JGJ0xXoIRO6rWNZwN/eQQQ8eHIDmk")
    ).to be_truthy
  end

  it 'short salt' do
    expect(
      Argon2::Password.verify_password("password", "$argon2i$v=19$m=65536,t=2,p=1$VG9vU2hvcnRTYWxlTGVu$i59ELgAm5G6J+9+oZwO+kkV48tJyocNh6bHdkj9J5lk")
    ).to be_truthy
  end
end
