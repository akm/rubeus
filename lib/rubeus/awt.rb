require "rubeus/component_loader"

module Rubeus
  Awt = ComponentLoader.new("java.awt")
end

require "rubeus/awt/attributes"
require "rubeus/awt/nestable"
require "rubeus/awt/event"
require "rubeus/awt/setters"
