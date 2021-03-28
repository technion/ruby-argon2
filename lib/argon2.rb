# frozen_string_literal: true

##
# This Ruby Gem provides FFI bindings and a simplified interface to the Argon2
# algorithm. Argon2 is the official winner of the Password Hashing Competition,
# a several year project to identify a successor to bcrypt/PBKDF/scrypt methods
# of securely storing passwords. This is an independent project and not official
# from the PHC team.
#
module Argon2; end

require 'argon2/constants'
require 'argon2/ffi_engine'
require 'argon2/version'
require 'argon2/errors'
require 'argon2/engine'
require 'argon2/password'
