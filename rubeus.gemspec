require 'rake'
Gem::Specification.new do |spec|
  spec.name = "rubeus"
  spec.version = "0.0.3"
  spec.platform = "java"
  spec.summary = "Rubeus provides you an easy access to Java objects from Ruby scripts on JRuby"
  spec.author = "Takeshi Akima"
  spec.email = "rubeus@googlegroups.com"
  spec.homepage = "http://code.google.com/p/rubeus/"
  spec.rubyforge_project = "rubybizcommons"
  spec.has_rdoc = false

  spec.add_dependency("activesupport", ">= 2.0.2")
  spec.files = FileList['lib/**/*.rb', 'examples/**/*.{rb,rtf}'].to_a
  spec.require_path = "lib"
  # spec.autorequire = 'rubeus' # autorequire is deprecated
end
