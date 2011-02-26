module Rubeus::Extensions::Javax::Swing
  module JMenuBar
    def self.included(klass)
      klass.perform_as_container
    end
  end
end