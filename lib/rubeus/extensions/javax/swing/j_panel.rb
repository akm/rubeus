Rubeus::Swing.depend_on("JComponent")

module Rubeus::Extensions::Javax::Swing
  module JPanel
    def self.included(base)
      base.perform_as_container
    end
  end
end
