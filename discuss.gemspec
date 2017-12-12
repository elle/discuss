$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'discuss/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'discuss'
  s.version     = Discuss::VERSION
  s.authors     = ['Elle Meredith', 'Garrett Heinlen']
  s.email       = ['elle.meredith@blake.com.au']
  s.homepage    = 'http://github.com/blake-education/discuss'
  s.summary     = 'Messaging engine'
  s.description = 'Messaging engine'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails',       '~> 4.0.13'
  s.add_dependency 'ancestry',    '~> 3.0.0'
  s.add_dependency 'haml',        '~> 5.0.4'
  s.add_dependency 'redcarpet',   '~> 3.4.0'
  s.add_dependency 'simple_form', '~> 3.5.0'
end
