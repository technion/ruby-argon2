# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'simplecov'
require 'simplecov-lcov'
SimpleCov::Formatter::LcovFormatter.config do |c|
  c.report_with_single_file = true
  c.output_directory = 'coverage/lvoc'
  c.lcov_file_name = 'lcov.info'
  c.single_report_path = 'coverage/lcov.info'
end
SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter
SimpleCov.start do
  # Don't test the coverage of the test suite itself...
  add_filter '/test'
end

require 'argon2'

require 'minitest/autorun'
