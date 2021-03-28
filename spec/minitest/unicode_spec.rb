# frozen_string_literal: true

require 'spec_helper'

describe 'UnicodeTest' do
  it 'accepts utf16' do
    # A string found on Google which encodes with a NULL byte
    unstr = "Σὲ γνωρίζω ἀπὸ τὴν κό".encode("utf-16le")
    argon2 = Argon2::Password.create(unstr)
    expect(Argon2::Password.verify_password(unstr, argon2)).to be_truthy
  end

  it 'accepts null byte' do
    rawstr = "String has a\0NULL in it"
    argon2 = Argon2::Password.create(rawstr)
    expect(Argon2::Password.verify_password(rawstr, argon2)).to be_truthy
    # Asserts that no NULL byte truncation occurs
    expect(Argon2::Password.verify_password("String has a", argon2)).to be_falsey
  end

  it 'accepts emoji 😄' do
    rawstr = "😀 😬 😁 😂 😃 😄 💩 😈 👿"
    argon2 = Argon2::Password.create(rawstr)
    expect(Argon2::Password.verify_password(rawstr, argon2)).to     be_truthy
    expect(Argon2::Password.verify_password("", argon2)).to         be_falsey
    expect(Argon2::Password.verify_password("        ", argon2)).to be_falsey
  end
end
