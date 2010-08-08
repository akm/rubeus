Rubeus::Awt.depend_on("Container", "Dimension")

module Rubeus::Extensions::Javax::Swing
  module JComponent

    def self.included(base)
      base.module_eval do
        alias_method :set_preferred_size, :set_preferred_size_rubeus
        alias_method :preferred_size=, :set_preferred_size_rubeus
      end
    end

    def set_preferred_size_rubeus(*args)
      dimension = Rubeus::Awt::Dimension
      java_send :setPreferredSize, [dimension], dimension.create(*args)
    end
  end
end
