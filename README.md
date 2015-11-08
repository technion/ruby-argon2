# Argon2

This Ruby Gem provides FFI bindings, and a simplified interface, to the Argon2 algorithm. [Argon2](https://github.com/P-H-C/phc-winner-argon2) is the official winner of the Password Hashing Competition, a several year project to identify a successor to bcrypt/PBKDF/scrypt methods of securely storing passwords. This is an independant project and not official from the PHC team.

*This gem is still in early development* and at this point is not recommended for use. The API however is now intended to have stabilised for any early testing.


[![Build Status](https://travis-ci.org/technion/ruby-argon2.svg?branch=master)](https://travis-ci.org/technion/ruby-argon2)

## Design

This project has several key tenants to its design:

* The reference Argon2 implementation is to be used "unaltered". To ensure this does not occur, and encourage regular updates from upstream, this is implemented as a git submodule, and is intended to stay that way.
* The FFI interface is kept as slim as possible, with wrapper classes preferred to implementing context structs in FFI
* Security and maintainability take top priority. This can have an impact on platform support. A PR that contains platform specific code paths is unlikely to be accepted.
* Errors from the C interface are raised as Exceptions. There are a lot of exception classes, but they tend to relate to things like very broken input, and code bugs. Calls to this library should generally not require a rescue.
* Test suits are aimed to be very comprehensive.
* Default work values should not be considered constants. I will increase them from time to time.

## Usage

Require this in your Gemfile like a typical Ruby gem:

    require 'argon2'

To generate a hash using specific time and memory cost:

    hasher = Argon2::Password.new(t_cost: 2, m_cost: 16)
    hasher.hash("password")
     => "$argon2i$m=65536,t=2,p=1$mLa9JT3Y9P2XhB5Mtuj+yQ$rojObVNKe/ehgd9SWQBB+8nJ8L34Aj3Kiz+aNrWvrx4"

To utilise default costs:

    hasher = Argon2::Password.new
    hasher.hash("password")

Alternatively, use this shotcut:

    Argon2::Password.hash("password")
     => "$argon2i$m=65536,t=2,p=1$AZwVlHIbgRC7yQhkPKa4tA$F5eM2Zzt4GhIVnR8SNOh3ysyMvGxAO6omsw8kzjbcs4"

You can then use this function to verify a password against a given hash. Will return either true or false.

    Argon2::Password.verify_password("password", secure_password)

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

Not yet - the code is in a high state of flux. If you feel you have identified a security issue, please email me directly. For any other bugs, it is too early to review them.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

