# -*- coding: utf-8 -*-
require 'minitest_helper'

# Test for j_table.rb
class TestJTable < MiniTest::Test
  include Rubeus::Swing

  # setup method
  def setup
  end

  # test default preferred size
  def test_default_preferred_size
    JFrame.new do |f|
      jt = JTable.new

      f.set_size(500, 500)
      f.pack

      assert_equal(200, jt.width)
      assert_equal(150, jt.height)

      f.dispose
    end
  end

  # test model accessor
  def test_model_accessor
    jt = JTable.new

    # set_model and model
    jt.set_model(["first", "second"])

    assert_equal(2, jt.model.column_count)
    assert_equal("first", jt.model.get_column_name(0))
    assert_equal("second", jt.model.get_column_name(1))

    # =model and get_model
    jt.model = ["third", "forth", "fifth"]

    assert_equal(3, jt.get_model.column_count)
    assert_equal("third", jt.get_model.get_column_name(0))
    assert_equal("forth", jt.get_model.get_column_name(1))
    assert_equal("fifth", jt.get_model.get_column_name(2))
  end

  # test model readonly
  def test_readonly
    jt = JTable.new

    # set test data
    jt.model = {:data => [["1", "ないわ〜"], ["2", "格好いい"]], :column_names => ["ID", "NHK語"]}

    for i in 0..(jt.model.row_count - 1)
      for j in 0..(jt.model.column_count - 1)
        assert_equal(true, jt.model.is_cell_editable(i, j))
      end
    end

    # set to readonly
    jt.model.readonly = true

    for i in 0..(jt.model.row_count - 1)
      for j in 0..(jt.model.column_count - 1)
        # is_cell_editable always returns true
        assert_equal(false, jt.model.isCellEditable(i, j))
      end
    end
  end
end
