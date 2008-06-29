module Rubeus::Extensions::Javax::Swing
  module JApplet
    def self.included(klass)
      klass.perform_as_container
    end
  end
end
