Rubeus::Swing.depend_on("JComponent")

module Rubeus::Swing::Extensions
  module JPanel
    def self.included(base)
      base.perform_as_container
    end
  end
end
