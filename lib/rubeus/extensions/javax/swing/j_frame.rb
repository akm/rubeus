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
          alias_method :size=, :set_size
        end
      end
    end

    if ENV_JAVA["java.specification.version"] == "1.6"
      def set_size(*args)
        java_send :setSize, [java.awt.Dimension],
          Rubeus::Awt::Dimension.create(*args)
      end
    end
  end
end
