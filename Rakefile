# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

HumanConnections::Application.load_tasks

# Added tasks for Code Coverage
require 'rcov/rcovtask' 
desc 'Measures test coverage using rcov'
namespace :rcov do
  desc 'Output unit test coverage of plugin.'
  Rcov::RcovTask.new(:units) do |rcov|
    rcov.pattern    = 'test/unit/**/*_test.rb'
    rcov.output_dir = 'coverage'
    rcov.verbose    = true
    rcov.rcov_opts << '--include test'
  end
 
  desc 'Output functional test coverage of plugin.'
  Rcov::RcovTask.new(:functionals) do |rcov|
    rcov.pattern    = 'test/functional/**/*_test.rb'
    rcov.output_dir = 'coverage'
    rcov.verbose    = true
    rcov.rcov_opts << '--include test'
  end
end
