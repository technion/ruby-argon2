# Ruby Argon2 Gem

This Ruby Gem provides FFI bindings, and a simplified interface, to the Argon2 algorithm. [Argon2](https://github.com/P-H-C/phc-winner-argon2) is the official winner of the Password Hashing Competition, a several year project to identify a successor to bcrypt/PBKDF/scrypt methods of securely storing passwords. This is an independant project and not official from the PHC team.

*This gem is now considered a beta release* and at this point is not recommended for production use. The more detailed advice here, is that it is feature complete, and I do not intend on making backward breaking API changes without bumping the Gem version semantically. There is complete tests and documentation, and I'm working on a project to put this into production.

However, at this point, the reference C library that we pull in is under active development, ([including from myself](https://github.com/P-H-C/phc-winner-argon2/pulls?q=is%3Apr+author%3Atechnion)), and this binding isn't released grade until that is.


[![Build Status](https://travis-ci.org/technion/ruby-argon2.svg?branch=master)](https://travis-ci.org/technion/ruby-argon2)
[![Code Climate](https://codeclimate.com/github/technion/ruby-argon2/badges/gpa.svg)](https://codeclimate.com/github/technion/ruby-argon2)
[![Test Coverage](https://codeclimate.com/github/technion/ruby-argon2/badges/coverage.svg)](https://codeclimate.com/github/technion/ruby-argon2/coverage)

## Design

This project has several key tenants to its design:

* The reference Argon2 implementation is to be used "unaltered". To ensure compliance wit this goal, and encourage regular updates from upstream, this is implemented as a git submodule, and is intended to stay that way.
* The FFI interface is kept as slim as possible, with wrapper classes preferred to implementing context structs in FFI
* Security and maintainability take top priority. This can have an impact on platform support. A PR that contains platform specific code paths is unlikely to be accepted.
* Tested platforms are MRI Ruby 2.2 and JRuby 9000. No assertions are made on other platforms.
* Errors from the C interface are raised as Exceptions. There are a lot of exception classes, but they tend to relate to things like very broken input, and code bugs. Calls to this library should generally not require a rescue.
* Test suits should aim for 100% code coverage.
* Default work values should not be considered constants. I will increase them from time to time.
* Not exposing the threads parameter is a design choice. I believe there is significant risk, and minimal gain in using a value other than '1'. Four threads on a four core box completely ties up the entire server to process one user logon. If you want more security, increase m_cost.
* Many Rubocop errors have been disabled, but any commit should avoid new alerts or demonstrate their necessity.

## Usage

Require this in your Gemfile like a typical Ruby gem:

```ruby
require 'argon2'
```

To generate a hash using specific time and memory cost:

```ruby
hasher = Argon2::Password.new(t_cost: 2, m_cost: 16)
hasher.hash("password")
     => "$argon2i$m=65536,t=2,p=1$mLa9JT3Y9P2XhB5Mtuj+yQ$rojObVNKe/ehgd9SWQBB+8nJ8L34Aj3Kiz+aNrWvrx4"
```

To utilise default costs:

```ruby
hasher = Argon2::Password.new
hasher.hash("password")
```

Alternatively, use this shotcut:

```ruby
Argon2::Password.hash("password")
     => "$argon2i$m=65536,t=2,p=1$AZwVlHIbgRC7yQhkPKa4tA$F5eM2Zzt4GhIVnR8SNOh3ysyMvGxAO6omsw8kzjbcs4"
```

You can then use this function to verify a password against a given hash. Will return either true or false.

```ruby
Argon2::Password.verify_password("password", secure_password)
```

Argon2 supports an optional key value. This should be stored securely on your server, such as alongside your database credentials. Hashes generated with a key will only validate when presented that key.

```ruby
KEY = "A key"
argon = Argon2::Password.new(t_cost: 2, m_cost: 16, secret: KEY)
myhash = argon.hash("A password")
Argon2::Password.verify_password("A password", myhash, KEY)
```

## RubyDocs documentation

[The usual URL](http://www.rubydoc.info/gems/argon2) will provide detailed documentation.

## FAQ
### Don't roll your own crypto!

This gets its own section because someone will raise it. I did not invent or alter this algorithm, or implement it directly.

### "Secure wipe is useless"

Although the low level C contains support for "secure memory wipe", any code hitting that layer has copied your password to a dozen places in memory. It should be assumed that such functionality does not exist.

### Work maximums may be tighter than reference

The reference implementation is aimed to provide secure hashing for many years. This implementation doesn't want you to DoS yourself in the meantime. Accordingly, some limits artificial limits exist on work powers. This gem can be much more agile in raising these as technology progresses.

### Salts in general

If you are providing your own salt, you are probably using it wrong. The design of any secure hashing system should take care of it for you.

## Contributing

Any form of contribution is appreciated, however, please note the design goals above and work within them.

If an issue is felt to be a security concern, please contact me privately on: technion@lolware.net. If required, you may encrypt with [my GPG key](https://lolware.net/technion-GPG-KEY).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

