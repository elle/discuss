$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'discuss/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'discuss'
  s.version     = Discuss::VERSION
  s.authors     = ['Elle Meredith', 'Garrett Heinlen']
  s.email       = ['ellemeredith@gmail.com']
  s.homepage    = 'http://github.com/blake-education/discuss'
  s.summary     = 'Messaging engine'
  s.description = 'Messaging engine'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails',         '>= 5.0.0', '< 7.0.0'

  s.add_dependency 'ancestry',      '~> 3.0.0'
  s.add_dependency 'redcarpet',     '~> 3.4.0'
  s.add_dependency 'simple_form',   '~> 4.1.0'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'minitest-reporters'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'sqlite3'
end
