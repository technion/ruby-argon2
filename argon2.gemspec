# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'argon2/version'

Gem::Specification.new do |spec|
  spec.name          = "argon2"
  spec.version       = Argon2::VERSION
  spec.authors       = ["Technion"]
  spec.email         = ["technion@lolware.net"]

  spec.summary       = 'Argon2 Password hashing binding'
  spec.description   = 'Argon2 FFI binding'
  spec.homepage      = 'https://github.com/technion/ruby-argon2'
  spec.license       = 'MIT'

  # TODO: Remove post install message after `v3.0.0` is released.
  spec.post_install_message =
    'Version 3.0 of the Argon2 ruby wrapper includes breaking changes on the '\
    'usage/generation of passwords. If you use Argon2 directly, you will need '\
    'to follow the "migrating to v3" guide in the project README. Otherwise '\
    'you can safely ignore this message.'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.files << `find ext`.split

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'ffi', '~> 1.14'
  spec.add_dependency 'ffi-compiler', '~> 1.0'

  spec.add_development_dependency "bundler", '~> 2.0'
  spec.add_development_dependency "minitest", '~> 5.8'
  spec.add_development_dependency "rake", '~> 13.0.1'
  spec.add_development_dependency "rubocop", '~> 1.7'
  spec.add_development_dependency "simplecov", '~> 0.20'
  spec.add_development_dependency "simplecov-lcov", '~> 0.8'
  spec.extensions << 'ext/argon2_wrap/extconf.rb'
end
