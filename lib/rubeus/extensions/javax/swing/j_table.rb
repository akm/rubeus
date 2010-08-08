Rubeus::Swing.depend_on('JComponent')
Rubeus::Swing.depend_on('TableModel')
Rubeus::Swing.depend_on('ReadonlyableTableModel')
Rubeus::Swing.depend_on('DefaultTableModel')

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
      unless model.is_a?(Rubeus::Swing::TableModel)
        model = Rubeus::Swing::DefaultTableModel.new(model, *args)
      end
      delegator = Rubeus::Swing::ReadonlyableTableModel.new(model)
      @model = delegator
      set_model_without_rubeus(@model)
    end
  end
end
