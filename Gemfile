source "https://rubygems.org"

# Declare your gem's dependencies in discuss.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# [e] this is to eliminate the scope depraction warnings since it is fixed in the master branch
gem 'ancestry', git: 'http://github.com/stefankroes/ancestry.git'

# To use debugger
# gem 'debugger'
group :test do
  gem 'haml'
  gem 'database_cleaner', git: 'https://github.com/bmabey/database_cleaner.git', tag: 'v1.0.0.RC1'
end
