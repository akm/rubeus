Rubeus::Swing.depend_on('TableModel')
Rubeus::Swing.depend_on('DelegatableTableModel')

module Rubeus::Extensions::Javax::Swing::Table
  module ReadonlyableTableModel
    def method_missing(method, *args, &block)
      self.source.send(method, *args, &block)
    end
  end
end
