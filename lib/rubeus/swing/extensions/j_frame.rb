Rubeus::Awt.depend_on('Container', 'Window', 'Frame')
Rubeus::Swing.depend_on('JPanel')

module Rubeus::Swing::Extensions
  module JFrame
    def self.included(base)
      base.perform_as_container
      base.default_attributes = {
        :size => [400, 300],
        :default_close_operation => javax.swing.JFrame::EXIT_ON_CLOSE
      }
    end
  end
end
