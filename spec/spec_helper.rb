# frozen_string_literal: true

SimpleCov::Formatter::LcovFormatter.config do |c|
  c.output_directory = 'coverage'
  c.lcov_file_name = 'lcov.info'
  c.single_report_path = './coverage/lcov.info'
  c.report_with_single_file = true
end

formatters = [SimpleCov::Formatter::Console, SimpleCov::Formatter::LcovFormatter]
SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new formatters

SimpleCov.start do
  add_group 'Project', ['../lib', '../db/models']
end

require_relative '../app'
require_relative '../rakefile'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['micro_learn:setup_database'].invoke
    FactoryBot.find_definitions
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  def response
    last_response
  end

  def json_response
    @json_response ||= JSON.parse(response.body)
  end
end
