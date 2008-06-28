module Rubeus::Swing::Components
  module JApplet
    def self.included(klass)
      klass.perform_as_container
    end
  end
end
