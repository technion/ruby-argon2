# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'argon2/version'

Gem::Specification.new do |spec|
  spec.name          = "argon2"
  spec.version       = Argon2::VERSION
  spec.authors       = ["Technion"]
  spec.email         = ["technion@lolware.net"]

  spec.summary       = %q{Argon2 Password hashing binding}
  spec.description   = %q{Not remotely finished Argon2 binding}
  spec.homepage      = "https://github.com/technion/ruby-argon2"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
#  submodule_path = 'ext/phc-winner-argon2/src'
#  `ls #{submodule_path}`.split.each do |filename|
#    spec.files << "#{submodule_path}/#{filename}"
#  end
  spec.files << `find ext`.split
  
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'ffi', '~> 1.9'
  spec.add_dependency 'ffi-compiler', '~> 0.1'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", '~> 5'
  spec.extensions << 'ext/argon2_wrap/extconf.rb'
end
