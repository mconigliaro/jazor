$:.push File.expand_path(File.join(File.dirname(__FILE__), "lib"))
require "jazor/app_info"

Gem::Specification.new do |s|
  s.name              = Jazor::NAME
  s.version           = Jazor::VERSION
  s.authors           = Jazor::AUTHOR
  s.email             = Jazor::AUTHOR_EMAIL
  s.homepage          = Jazor::URL
  s.rubyforge_project = Jazor::NAME
  s.summary           = Jazor::DESCRIPTION
  s.description       = Jazor::DESCRIPTION

  s.add_dependency "json"
  s.add_dependency "term-ansicolor"

  s.add_development_dependency "rake"
  s.add_development_dependency "minitest"
  s.add_development_dependency "autotest"

  s.files         = `git ls-files`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
end
