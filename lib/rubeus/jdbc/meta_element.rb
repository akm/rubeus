module Rubeus::Jdbc
  class MetaElement
    attr_reader :meta_data, :jdbc_info, :options
    def initialize(meta_data, attrs, options = nil)
      @meta_data = meta_data
      @jdbc_info = attrs.dup
      attrs.each do |attr, value|
        m = "#{attr.downcase}="
        self.send(m, value) if respond_to?(m)
      end
      @options = options ? options.dup : {}
    end
    
    def pretty_print_instance_variables
      self.instance_variables.sort.map(&:to_sym) - [:@meta_data, :@jdbc_info, :@table]
    end
  end
end
