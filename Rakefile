require 'rubygems'
require 'rake'

begin
  gem 'rspec', '~> 2.0.0'
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new
rescue LoadError
  task :spec do
    abort "Please run `gem install rspec` to install RSpec."
  end
end
task :default => :spec

begin
  gem 'yard', '~> 0.6.0'
  require 'yard'
  
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yard do
    abort "Please run `gem install yard` to install YARD."
  end
end
