source 'https://rubygems.org'

group :test do
  gem 'rake'
  gem 'puppet', ENV['PUPPET_VERSION'] || '~> 3.8.0'
  gem 'rspec', '< 3.2.0'
  gem 'rspec-puppet'
  gem 'puppetlabs_spec_helper'
  gem 'metadata-json-lint'
  gem 'rspec-puppet-facts'
end

group :development do
  gem 'travis'
  gem 'travis-lint'
  gem 'guard-rake'
end

group :system_tests do
  gem 'beaker'
  gem 'beaker-rspec'
  # gem 'bundler', '<= 1.10.5' # Ensure your version matches if
  # running beaker tests
end
