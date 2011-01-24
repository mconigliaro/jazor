$:.push File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require 'jazor'

Gem::Specification.new do |s|
  s.name              = Jazor::NAME
  s.version           = Jazor::VERSION
  s.authors           = [Jazor::AUTHOR]
  s.email             = [Jazor::AUTHOR_EMAIL]
  s.homepage          = Jazor::URL
  s.rubyforge_project = Jazor::NAME
  s.summary           = 'Jazor is a simple command line JSON parsing tool'
  s.description       = 'Jazor is a simple command line JSON parsing tool'

  s.add_dependency('json')

  s.files = ['COPYING.txt', 'Rakefile', 'README.rdoc'] + Dir['bin/*'] + Dir['lib/*.rb'] + Dir['test/*']
  s.executables = ['jazor']
end
