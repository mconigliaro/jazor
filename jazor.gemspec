Gem::Specification.new do |s|
  s.name              = 'jazor'
  s.version           = '0.0.1'
  s.authors           = ["Michael T. Conigliaro"]
  s.email             = ["mike [at] conigliaro [dot] org"]
  s.homepage          = "http://github.com/mconigliaro/jazor"
  s.rubyforge_project = 'jazor'
  s.summary           = 'Jazor is a simple command line JSON parsing tool'
  s.description       = 'Jazor is a simple command line JSON parsing tool'

  s.add_dependency('json')

  s.files = ['COPYING.txt', 'README.rdoc'] + Dir['lib/*.rb'] + Dir['bin/*.rb']
end
