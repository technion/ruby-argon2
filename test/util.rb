#!/usr/bin/env ruby
#Utility to turn hex reference vectors to base64
#Used to generate tests, not an actively used test
require_relative 'util_lib'

if ARGV[0]
  puts conversion(ARGV[0])
else
  fail "Input required"
end
