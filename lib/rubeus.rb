require "rubeus/version"

require 'java'
require File.join(File.dirname(__FILE__), 'rubeus.jar')

# require "rubygems"
# gem "activesupport", "=2.1.2"
# require "active_support"
require "active_support/core_ext/string"

Kernel.module_eval <<-EOS
  def jp
    JavaUtilities.get_package_module_dot_format('jp')
  end
EOS

module Rubeus
  VERSION = '0.0.9'
  EMAIL_GROUP = 'rubeus@googlegroups.com'
  WEB_SITE = 'http://code.google.com/p/rubeus/'

  autoload :Verbosable, "rubeus/verboseable"

  autoload :Awt, "rubeus/awt"
  autoload :Swing, "rubeus/swing"
  autoload :Jdbc, "rubeus/jdbc"
  autoload :Reflection, "rubeus/reflection"
  autoload :Util, "rubeus/util"

  def self.verbose; @verbose; end
  def self.verbose=(value); @verbose = value; end
end

unless File.basename($PROGRAM_NAME) == 'gem' and ARGV.first == 'build'
  require "rubeus/extensions"
end
