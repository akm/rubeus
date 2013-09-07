# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubeus/version'

Gem::Specification.new do |spec|
  spec.name          = "rubeus"
  spec.version       = Rubeus::VERSION
  spec.platform      = %q{java}
  spec.authors       = ["akimatter"]
  spec.email         = ["rubeus@googlegroups.com"]
  spec.description   = %q{Rubeus provides you an easy access to Java objects from Ruby scripts on JRuby}
  spec.summary       = %q{Rubeus provides you an easy access to Java objects from Ruby scripts on JRuby}
  spec.homepage      = "http://code.google.com/p/rubeus/"
  spec.license       = "MIT"
  # spec.date        = %q{2010-08-28}

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", "< 4.0.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"

  spec.add_development_dependency "jdbc-derby", "10.6.2.1"
  spec.add_development_dependency "rmaven", "0.0.1"
end
