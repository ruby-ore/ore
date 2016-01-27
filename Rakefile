require 'rubygems'

begin
  require 'bundler/setup'
rescue LoadError => e
  abort e.message
end

require 'rake'

require 'rubygems/tasks'
Gem::Tasks.new

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

task :test => :spec
task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new

namespace :update do
  Dir['data/ore/templates/*'].each do |template|
    name = File.basename(template)

    if File.exist?(File.join(template,'.git'))
      desc "Updates the #{name} template"
      task name do
        Dir.chdir(template) { sh 'git pull' }
        sh 'git', 'commit', template
      end
    end
  end
end
