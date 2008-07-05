require "rubygems"
gem "activesupport", ">=2.0.2"
# require "active_support"
require "active_support/core_ext/string"

module Rubeus
  VERSION = "0.0.2"
  autoload :Extensions, "rubeus/extensions"
  autoload :Awt, "rubeus/awt"
  autoload :Swing, "rubeus/swing"
  # autoload :Jdbc, "rubeus/jdbc"
end
