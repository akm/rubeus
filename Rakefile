require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'rubygems'
require 'rmaven'
require 'tasks/mvn'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the selectable_attr plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << File.join(File.dirname(__FILE__), 'lib') 
  t.pattern = File.join(File.dirname(__FILE__), 'test', 'rubeus', '**', 'test_*.rb')
  t.verbose = true
end

desc 'Generate documentation for the selectable_attr plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Rubeus'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
