Rubeus::Awt.depend_on("Dimension")

module Rubeus::Awt::Extensions
  module Component
    def self.included(base)
      base.module_eval do
        include Rubeus::Awt::Attributes
        include Rubeus::Awt::Nestable
        include Rubeus::Awt::Event
        include Rubeus::Awt::Setters
      end
    end
  end
end
