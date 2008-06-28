module Rubeus::Swing
  module JComponent
    def self.included(klass)
      klass.module_eval do
        alias_method :set_preferred_size_without_rubeus, :set_preferred_size
        alias_method :set_preferred_size, :set_preferred_size_with_rubeus
      end
    end
    
    def set_preferred_size_with_rubeus(*args)
      values = args
      if args.length == 1
        if args.first.is_a?(java.awt.Dimension)
          return set_preferred_size_without_rubeus(*args)
        else
          values = args.first.to_s.split("x", 2)
        end
      end
      set_preferred_size_without_rubeus(java.awt.Dimension.new(*values.map{|s|s.to_i}))
    end
  end
end
