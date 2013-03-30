require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name        = "cloudapp_api"
  gem.homepage    = "http://github.com/aaronrussell/cloudapp_api"
  gem.summary     = %Q{A simple Ruby wrapper for the CloudApp API. Uses HTTParty with a simple ActiveResource-like interface.}
  gem.description = %Q{A simple Ruby wrapper for the CloudApp API. Uses HTTParty with a simple ActiveResource-like interface.}
  gem.email       = "aaron@gc4.co.uk"
  gem.authors     = ["Aaron Russell"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  gem.add_runtime_dependency "httparty", ">= 0.6.0"
  gem.add_development_dependency "rspec", "~> 2.1.0"
  gem.add_development_dependency "yard", "~> 0.6.0"
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
  spec.verbose
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
