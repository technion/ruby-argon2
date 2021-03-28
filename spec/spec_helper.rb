# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'byebug'
require 'faker'

############################
## Generate Test Coverage ##
############################

unless ENV['coverage'] == 'false'
  require 'simplecov'
  require 'simplecov-lcov'
  SimpleCov::Formatter::LcovFormatter.config do |c|
    c.report_with_single_file = true
    c.output_directory = 'coverage/lvoc'
    c.lcov_file_name = 'lcov.info'
    c.single_report_path = 'coverage/lcov.info'
  end
  SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter
  SimpleCov.start
end

#####################
## Configure RSpec ##
#####################

RSpec.configure do |config|
  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Find load order dependencies
  config.order = :random
  # Allow replicating load order dependency
  # by passing in same seed using --seed
  Kernel.srand config.seed

  # Find slow specs by running `profiling=true rspec`
  config.profile_examples = 5 if ENV['profiling'] == 'true'
end

######################
## Load the Library ##
######################

require 'argon2'
