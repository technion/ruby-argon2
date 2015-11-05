#!/usr/bin/env ruby
#Utility to turn hex reference vectors to base64
#Used to generate tests, not an actively used test

def conversion(inhex)
  hex = inhex
  binary = hex.scan(/../).map { |x| x.hex.chr }.join
  b64 = [binary].pack("m0")
  b64.gsub('=', '') #Trim padding for standard
end

