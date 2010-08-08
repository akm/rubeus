Rubeus::Awt.depend_on("Dimension")

module Rubeus::Awt
  module Setters

    def self.included(base)
      base.module_eval do
        alias_method :set_preferred_size, :set_preferred_size_rubeus
        alias_method :preferred_size=, :set_preferred_size_rubeus
        alias_method :set_size, :set_size_rubeus
        alias_method :size=, :set_size_rubeus
      end
    end

    def set_size_rubeus(*args)
      java_send :setSize, [Dimension], Dimension.create(*args)
    end

    def set_preferred_size_rubeus(*args)
      java_send :setPreferredSize, [Dimension], Dimension.create(*args)
    end
  end
end
