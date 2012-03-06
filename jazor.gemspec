$:.push File.expand_path(File.join(File.dirname(__FILE__), "lib"))
require "jazor"

Gem::Specification.new do |s|
  s.name              = Jazor::NAME
  s.version           = Jazor::VERSION
  s.authors           = Jazor::AUTHOR
  s.email             = Jazor::AUTHOR_EMAIL
  s.homepage          = Jazor::URL
  s.rubyforge_project = Jazor::NAME
  s.summary           = Jazor::DESCRIPTION
  s.description       = Jazor::DESCRIPTION

  s.add_dependency("bundler")
  s.add_dependency("json")

  s.add_development_dependency("rake")
  s.add_development_dependency("rspec")

  s.files       = ["jazor.gemspec", "Gemfile", "Gemfile.lock", "README.md"] + Dir["bin/*"] + Dir["lib/*.rb"]
  s.test_files  = ["Rakefile"] + Dir["spec/*"]
  s.executables = ["jazor"]
end
