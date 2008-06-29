Rubeus::Awt.depend_on("Container")

module Rubeus::Extensions::Javax::Swing
  module JComponent
    
    def self.included(base)
      base.module_eval do
        alias_method :set_preferred_size_without_rubeus, :set_preferred_size
        alias_method :set_preferred_size, :set_preferred_size_with_rubeus
        alias_method :preferred_size=, :set_preferred_size_with_rubeus
      end
    end
    
    def set_preferred_size_with_rubeus(*args)
      set_preferred_size_without_rubeus(Rubeus::Awt::Dimension.create(*args))
    end
    
  end
end
