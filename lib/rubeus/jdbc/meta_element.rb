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
      self.instance_variables.sort.map{|v| v.to_sym} - [:@meta_data, :@jdbc_info, :@table]
    end
  end

  class TableElement < MetaElement
    attr_reader :table

    def initialize(meta_data, table, *args, &block)
      super(meta_data, *args, &block)
      @table = table
    end
    
    def pretty_print_instance_variables
      super - [:@table]
    end
  end
end
