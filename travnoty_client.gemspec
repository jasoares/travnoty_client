# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'travnoty_client/version'

Gem::Specification.new do |gem|
  gem.name          = "travnoty_client"
  gem.version       = TravnotyClient::VERSION
  gem.authors       = ["João Soares"]
  gem.email         = ["jsoaresgeral@gmail.com"]
  gem.description   = %q{Travnoty client side app}
  gem.summary       = gem.description
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib", "~/work/projects/travnoty/lib", "~/work/projects/travian_client/lib"]

  gem.add_dependency 'wxruby-ruby19', '2.0.0'
end
