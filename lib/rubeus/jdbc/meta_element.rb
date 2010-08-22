module Rubeus::Jdbc
  class MetaElement
    attr_reader :meta_data, :jdbc_info, :options
    def initialize(meta_data, attrs, options = nil)
      @meta_data = meta_data
      @jdbc_info = attrs.dup
      attrs.each do |attr, value|
        m = "#{attr.to_s.downcase}="
        self.send(m, value) if respond_to?(m)
      end
      @options = options ? options.dup : {}
    end

    def pretty_print_instance_variables
      self.instance_variables.sort.map{|v| v.to_sym} - [:@meta_data, :@jdbc_info, :@table]
    end

  end

  module FullyQualifiedNamed
    FQN_ATTRS = [:table_cat, :table_schem, :table_name]
    FQN_ATTR_STRS = FQN_ATTRS.map{|attr| attr.to_s.upcase}

    attr_accessor *FQN_ATTRS

    def fully_qualified_name
      [table_cat, table_schem, table_name]
    end
    alias_method :fqn, :fully_qualified_name

    def same_fqn?(element)
      if element.is_a?(Hash)
        FQN_ATTR_STRS.all?{|attr|
          jdbc_info[attr] == element[attr]
        }
      elsif element.is_a?(Array)
        fully_qualified_name == element
      elsif element.respond_to?(:fully_qualified_name)
        fully_qualified_name == element.fully_qualified_name
      else
        raise ArgumentError, "Unsupported Object #{element.inspect}. Must be a Hash or a object which have 'fully_qualified_name' method."
      end
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
