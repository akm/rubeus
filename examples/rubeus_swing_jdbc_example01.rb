require 'rubygems'
require "rubeus"
Rubeus::Swing.irb

@conn = Rubeus::Jdbc::DriverManager.
  connect("jdbc:derby:test_db;create = true")
tables = @conn.meta_data.tables(:schema => "APP")

JFrame.new("Rubeus Swing Example 01") do |frame|
  frame.layout = BoxLayout.new(:X_AXIS)
  JSplitPane.new(JSplitPane::HORIZONTAL_SPLIT) do
    JScrollPane.new(:preferred_size => [150, 250]) do |pane|
      @list = JList.new(tables.map(&:name).to_java) do |event|
        table_name = @list.selected_value.inspect
        @conn.query("select * from #{table_name}") do |rs|
          @table.model = rs.map{|row| row.to_a}
        end
      end
    end
    JScrollPane.new{|pane| @table = JTable.new}
  end
  frame.visible = true
end
