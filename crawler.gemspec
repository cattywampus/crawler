# -*- encoding: utf-8 -*-
require File.expand_path('../lib/crawler/version', __FILE__)

Gem::Specification.new do |gem|  
  gem.authors       = ["Keith Walters"]
  gem.email         = ["keith.walters@cattywamp.us"]
  gem.description   = %q{Scrapes a list of URLs to check if their links work}
  gem.summary       = %q{URL link checker}
  gem.homepage      = "https://github.com/cattywampus/crawler"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = ["crawler"]
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "crawler"
  gem.require_paths = ["lib"]
  gem.version       = Crawler::VERSION


  gem.add_runtime_dependency "mechanize"
  gem.add_runtime_dependency "ruby-progressbar"

  gem.add_development_dependency "minitest"
end  
