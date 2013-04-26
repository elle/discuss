$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'discuss/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'discuss'
  s.version     = Discuss::VERSION
  s.authors     = ['Elle Meredith', 'Garrett Heinlen', 'Nick Sutterer']
  s.email       = ['elle.meredith@blake.com.au']
  s.homepage    = 'http://labs.blake.com.au'
  s.summary     = 'Messaging engine'
  s.description = 'Messaging engine'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails',         '~> 4.0.0.beta1'
  #s.add_dependency 'ancestry',      '~> 1.3.0'
  s.add_dependency 'haml',          '~> 4.0.2'
  s.add_dependency 'simple_form',   '~> 1.4.1'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'debugger'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'minitest-reporters'
end
