module Rubeus::Jdbc
  class MetaElement
    attr_reader :meta_data, :jdbc_info
    def initialize(meta_data, options)
      @meta_data = meta_data
      @jdbc_info = options.dup
      options.each do |attr, value|
        m = "#{attr.downcase}="
        self.send(m, value) if respond_to?(m)
      end
    end
    
    def pretty_print_instance_variables
      self.instance_variables.sort.map(&:to_sym) - [:@meta_data, :@jdbc_info, :@table]
    end
  end
end
