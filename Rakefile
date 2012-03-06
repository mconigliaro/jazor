require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:test) do |t|
  t.rspec_opts = [
    "-f doc",
    "-r #{File.expand_path(File.join(File.dirname(__FILE__), "lib", "jazor.rb"))}"
  ]
end

task :default => :test
