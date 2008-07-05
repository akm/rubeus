Rubeus::Awt.depend_on('Container', 'Window', 'Frame')
Rubeus::Swing.depend_on('JPanel')

module Rubeus::Extensions::Javax::Swing
  module JFrame
    def self.included(base)
      base.perform_as_container
      base.default_attributes = {
        :size => [400, 300],
        :default_close_operation => :EXIT_ON_CLOSE
      }
      if ENV_JAVA["java.specification.version"] == "1.6"
        base.module_eval do
          alias_method :set_size_without_rubeus, :set_size
          alias_method :set_size, :set_size_with_rubeus
          alias_method :size=, :set_size_with_rubeus
        end
      end
    end
    
    if ENV_JAVA["java.specification.version"] == "1.6"
      def set_size_with_rubeus(*args)
        set_size_without_rubeus(Rubeus::Awt::Dimension.create(*args))
      end
    end
  end
end
