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
      base.module_eval do
        alias_method :set_size_without_rubeus, :set_size
        alias_method :set_size, :set_size_with_rubeus
        alias_method :size=, :set_size_with_rubeus
      end
    end
    
    # for Java6
    def set_size_with_rubeus(*args)
      set_size_without_rubeus(Rubeus::Awt::Dimension.create(*args))
    end
  end
end
