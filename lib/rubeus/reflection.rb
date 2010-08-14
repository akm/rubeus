# -*- coding: utf-8 -*-
require "rubeus/component_loader"

module Rubeus
  Reflection = ComponentLoader.new("java.lang.reflect") do

    def self.irb
      self.extend_with
    end
  end
end
