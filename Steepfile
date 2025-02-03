# frozen_string_literal: true

target :lib do
  signature "sig"

  check "argon2.rb"
  check "lib" # Directory name
  ignore "lib/argon2/ffi_engine.rb"
  ignore "lib/argon2/errors.rb"
end

target :spec do
  signature "sig", "sig-private"

  check "spec"
end
