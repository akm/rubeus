require "rubygems"
gem "activesupport", ">=2.0.2"
# require "active_support"
require "active_support/core_ext/string"

module Rubeus
  VERSION = "0.0.5"
  autoload :Awt, "rubeus/awt"
  autoload :Swing, "rubeus/swing"
  # autoload :Jdbc, "rubeus/jdbc"
end

unless File.basename($PROGRAM_NAME) == 'gem' and ARGV.first == 'build'
  require "rubeus/extensions"
end
