require 'rake'
require(File.join(File.dirname(__FILE__), 'lib', 'rubeus'))

Gem::Specification.new do |spec|
  spec.name = "rubeus"
  spec.version = Rubeus::VERSION
  spec.platform = "java"
  spec.summary = "Rubeus provides you an easy access to Java objects from Ruby scripts on JRuby"
  spec.author = "Takeshi Akima"
  spec.email = "rubeus@googlegroups.com"
  spec.homepage = "http://code.google.com/p/rubeus/"
  spec.rubyforge_project = "rubybizcommons"
  spec.has_rdoc = false

  spec.add_dependency("activesupport", ">= 2.0.2")
  spec.files = FileList['bin/*', '{lib,examples}/**/*.{rb,rtf,png}'].to_a
  spec.require_path = "lib"
  spec.requirements = ["none"]
  spec.autorequire = 'rubeus' # autorequire is deprecated
  
  bin_files = FileList['bin/*'].to_a.map{|file| file.gsub(/^bin\//, '')}
  spec.executables = bin_files

  puts bin_files

  spec.default_executable = 'jirb_rubeus'
end
