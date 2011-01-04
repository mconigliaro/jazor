task :default => [:test]

task :test do
  Dir[File.expand_path(File.join(File.dirname(__FILE__), 'test', 'test_*'))].each do |test|
    system "ruby #{test}"
  end
end

task :build do
  system "gem build jazor.gemspec"
end
