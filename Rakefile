# -*- coding: utf-8 -*-
require 'rubygems'
begin
  require 'rmaven'
  require 'tasks/mvn'
rescue LoadError
  puts "rmaven (or a dependency) not available. Install it with: gem install rmaven"
end
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rubeus"
    gem.platform = "java"
    gem.summary = %Q{Rubeus provides you an easy access to Java objects from Ruby scripts on JRuby}
    gem.description = %Q{Rubeus provides you an easy access to Java objects from Ruby scripts on JRuby}
    gem.email = "rubeus@googlegroups.com"
    gem.homepage = "http://code.google.com/p/rubeus/"
    gem.authors = ["akimatter"]
    gem.add_dependency "activesupport", "= 2.1.2"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
    gem.add_development_dependency "rcov", ">= 0.9.8"
    gem.bindir = 'bin'
    gem.executables = %w[jirb_rubeus jirb_rubeus.bat]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.rcov_opts = ['--text-report', '--exclude "test/*,gems/*"']
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rubeus #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
