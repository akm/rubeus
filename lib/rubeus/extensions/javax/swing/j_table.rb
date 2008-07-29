Rubeus::Swing.depend_on('JComponent')
Rubeus::Swing.depend_on('DefaultTableModel')
require 'delegate'

module Rubeus::Extensions::Javax::Swing
  module JTable
    def self.included(base)
      base.default_attributes = {
        :preferred_size => [200, 150]
      }
      base.module_eval do
        alias_method :get_model_without_rubeus, :get_model
        alias_method :get_model, :get_model_with_rubeus
        alias_method :model, :get_model

        alias_method :set_model_without_rubeus, :set_model
        alias_method :set_model, :set_model_with_rubeus
        alias_method :model=, :set_model
      end
    end
    
    def get_model_with_rubeus
      @model || get_model_without_rubeus
    end
    
    def set_model_with_rubeus(model, *args)
      unless model.is_a?(javax.swing.table.TableModel)
        model = javax.swing.table.DefaultTableModel.new(model, *args)
      end
      delegator = DelegatableTableModel.new(model)
      set_model_without_rubeus(@model = delegator)
    end

    class DelegatableTableModel
      # include javax.swing.table.TableModel
      
      attr_accessor :readonly
      
      def initialize(source)
        @source = source
      end

      def method_missing(method, *args, &block)
        @source.__send__(method, *args, &block)
      end
      
      def isCellEditable(row, col)
        !readonly
      end
    end
  end
end
