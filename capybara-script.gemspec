# -*- encoding: utf-8 -*-
require File.expand_path('../lib/capybara/script/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Daniel Leavitt"]
  gem.email         = ["daniel.leavitt@gmail.com"]
  gem.summary       = "Run Capybara sessions via a serializable list of steps."
  gem.description   = "Run Capybara sessions via a serializable list of steps."
  gem.homepage      = "https://github.com/dleavitt/capybara-script"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "capybara-script"
  gem.require_paths = ["lib"]
  gem.version       = Capybara::Script::VERSION
  
  gem.add_runtime_dependency      %q<activesupport>,        ["~> 3.1"]
  gem.add_runtime_dependency      %q<capybara>,             ["~> 1.1"]
  gem.add_development_dependency  %q<rspec>,                ["~> 2.10"]
  gem.add_development_dependency  %q<capybara-webkit>,      ["~> 0.12"]
  gem.add_development_dependency  %q<rake>,                 ["~> 0.9"]
  gem.add_development_dependency  %q<rspec>,                ["~> 2.10"]
  gem.add_development_dependency  %q<pry>,                  ["~> 0.9"]
  gem.add_development_dependency  %q<awesome_print>,        ["~> 1.0"]
end
