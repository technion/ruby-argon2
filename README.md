# Argon2

An FFI binding for Argon2.
This gem is nowhere near finished.

Until it is, please refer to the test suite for documentation. Currently implemented:

    assert_equal Argon2.hash_argon2i_encode("password",  "somesalt\0\0\0\0\0\0\0
            \0"), '$argon2i$m=65536,t=2,p=4$c29tZXNhbHQAAAAAAAAAAA$JGFyZ29uMmkkbT02NTUzNix0PTIscD00JGMyOXRaWE4'


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'argon2'
```


## Contributing

Not yet - the code is in a high state of flux.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

