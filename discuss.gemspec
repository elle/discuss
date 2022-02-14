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

  s.add_dependency 'rails',         '>= 5.2.0', '< 7.0.0'

  s.add_dependency 'ancestry',      '~> 4.0' # message model
  s.add_dependency 'jquery-rails',  '>= 4.4'
  s.add_dependency 'redcarpet',     '~> 3.5'
  s.add_dependency 'simple_form',   '~> 4.1'
  s.add_dependency 'sprockets',     '>= 2.0.0', '< 4.0.0'
end
