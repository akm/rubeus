require "rubygems"
gem "activesupport", ">=2.0.2"
# require "active_support"
require "active_support/core_ext/string"

module Rubeus
  VERSION = '0.0.7'
  EMAIL_GROUP = 'rubeus@googlegroups.com'
  WEB_SITE = 'http://code.google.com/p/rubeus/'
  
  autoload :Verbosable, "rubeus/verboseable"
  
  autoload :Awt, "rubeus/awt"
  autoload :Swing, "rubeus/swing"
  autoload :Jdbc, "rubeus/jdbc"

  def self.verbose; @verbose; end
  def self.verbose=(value); @verbose = value; end
end

unless File.basename($PROGRAM_NAME) == 'gem' and ARGV.first == 'build'
  require "rubeus/extensions"
end
