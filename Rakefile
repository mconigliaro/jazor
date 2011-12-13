require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc 'Build the gem'
task :build do
  system "gem build *.gemspec"
end

desc 'Push the gem'
task :push do
  system "gem push *.gem"
end
