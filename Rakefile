# -*- coding: utf-8 -*-
require 'rubygems'
begin
  require 'rmaven'
  require 'tasks/mvn'
rescue LoadError
  puts "rmaven (or a dependency) not available. Install it with: gem install rmaven"
end

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/test_*.rb']
end

task :default => :test
