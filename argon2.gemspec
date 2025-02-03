# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'argon2/version'

Gem::Specification.new do |spec|
  spec.name          = "argon2"
  spec.version       = Argon2::VERSION
  spec.authors       = ["Technion"]
  spec.email         = ["technion@lolware.net"]

  spec.required_ruby_version = '>= 2.6.0'

  spec.summary       = 'Argon2 Password hashing binding'
  spec.description   = 'Argon2 FFI binding'
  spec.homepage      = 'https://github.com/technion/ruby-argon2'
  spec.license       = 'MIT'
  spec.metadata      = {
    'rubygems_mfa_required' => 'true'
  }

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.files << `find ext`.split

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'ffi', '~> 1.15'
  spec.add_dependency 'ffi-compiler', '~> 1.0'

  spec.add_development_dependency "bundler", '~> 2.0'
  spec.add_development_dependency "minitest", '~> 5.8'
  spec.add_development_dependency "rake", '~> 13.0.1'
  spec.add_development_dependency "rubocop", '~> 1.7'
  spec.add_development_dependency "simplecov", '~> 0.20'
  spec.add_development_dependency "simplecov-lcov", '~> 0.8'
  spec.add_development_dependency "steep", "~> 1.9.3"
  spec.extensions << 'ext/argon2_wrap/extconf.rb'
end
