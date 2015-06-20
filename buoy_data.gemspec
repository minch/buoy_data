require File.expand_path("../lib/buoy_data/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name    = 'buoy_data'
  gem.version = BuoyData::VERSION
  gem.date    = Date.today.to_s

  gem.summary = 'Fetch marine buoy data from various sources'

  gem.authors  = ['Adam Weller']
  gem.email    = 'minch@lowpressure.org'
  gem.homepage = 'http://github.com/minch/buoy_data'

  gem.add_dependency('rake')
  gem.add_dependency('httparty')
  gem.add_dependency('nokogiri')
  gem.add_development_dependency('rspec', [">= 2.0.0"])

  # ensure the gem is built out of versioned files
  gem.files = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
end
