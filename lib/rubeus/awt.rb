require "rubeus/component_loader"

module Rubeus
  Awt = ComponentLoader.new("java.awt") do
    class_to_package.update(
      # $JAVA_HOME/lib/classlistにないものリスト
      'DnDConstants' => 'java.awt.dnd'
      )
  end
end

require "rubeus/awt/attributes"
require "rubeus/awt/nestable"
require "rubeus/awt/event"
require "rubeus/awt/setters"
