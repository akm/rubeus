module Rubeus::Swing::Extensions
  module JApplet
    def self.included(klass)
      klass.perform_as_container
    end
  end
end
