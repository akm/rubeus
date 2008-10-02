# -*- coding: utf-8 -*-
require 'test/unit'
require 'rubygems'
require 'rubeus'
require 'rexml/document'

# Rubeus.verbose = true

# Test for Rubeus::Extensions::Javax::Swing::Table
class TestDefaultTableModel < Test::Unit::TestCase
  include Rubeus::Swing

  # setup method
  def setup
    # Load XML File
    open(File.join(File.dirname(__FILE__), 'test_default_table_model', 'nhk_words.xml')) do |f|
      @xml = REXML::Document.new(f)
    end
  end

  # normal pattern
  def test_load_from_xml_normal
    # Initialize JTable and model
    nhk_word_table = JTable.new
    nhk_word_table.model = ['ID', 'NHK語']

    # load_from_xml
    nhk_word_table.model.load_from_xml(@xml,
      :row_path => '*/nhk-word',
      :column_paths => ['id', 'expression'])

    assert_for_normal(nhk_word_table)
  end

  # utility for assert method for normal
  def assert_for_normal(nhk_word_table)
    # assert row count
    assert_equal(2, nhk_word_table.model.row_count)

    # assert first row
    assert_equal("1", nhk_word_table.model.get_value_at(0, 0))
    assert_equal("ないわ～", nhk_word_table.model.get_value_at(0, 1))

    # assert second row
    assert_equal("2", nhk_word_table.model.get_value_at(1, 0))
    assert_equal("格好いい", nhk_word_table.model.get_value_at(1, 1))
  end
  private :assert_for_normal

  # row_path is nil
  def test_load_from_xml_nil_row_path
    # Initialize JTable and model
    nhk_word_table = JTable.new
    nhk_word_table.model = ['ID', 'NHK語']

    # load_from_xml
    assert_raise(ArgumentError) do
      nhk_word_table.model.load_from_xml(@xml,
        :column_paths => ['id', 'expression'])
    end
  end

  # invalid row_path
  def test_load_from_xml_invalid_row_path
    # Initialize JTable and model
    nhk_word_table = JTable.new
    nhk_word_table.model = ['ID', 'NHK語']

    # load_from_xml
    nhk_word_table.model.load_from_xml(@xml,
      :row_path => '*/nhk-words',
      :column_paths => ['id', 'expression'])

    # assert row count
    assert_equal(0, nhk_word_table.model.row_count)
  end

  # nil column_paths
  def test_load_from_xml_nil_column_paths
    # Initialize JTable and model
    nhk_word_table = JTable.new
    nhk_word_table.model = ['ID', 'NHK語']

    # load_from_xml
    nhk_word_table.model.load_from_xml(@xml,
      :row_path => '*/nhk-word')

    # assert for normal
    assert_for_normal(nhk_word_table)
  end

  # nil column_paths with refresh_columns
  def test_load_from_xml_nil_column_paths_with_refresh_columns
    # Initialize JTable and model
    nhk_word_table = JTable.new
    nhk_word_table.model = ['ID', 'NHK語']

    # load_from_xml
    nhk_word_table.model.load_from_xml(@xml,
      :row_path => '*/nhk-word',
      :refresh_columns => true)

    # assert for normal
    assert_for_normal(nhk_word_table)
  end

  # invalid column_paths
  def test_load_from_xml_invalid_column_paths
    # Initialize JTable and model
    nhk_word_table = JTable.new
    nhk_word_table.model = ['ID', 'NHK語']

    # load_from_xml
    assert_raise(ArgumentError) do
      nhk_word_table.model.load_from_xml(@xml,
        :row_path => '*/nhk-word',
        :column_paths => ['ida', 'expression'])
    end
  end

  # less number of columns
  def test_load_from_xml_less_number_of_columns
    # Initialize JTable and model
    nhk_word_table = JTable.new
    nhk_word_table.model = ['ID', 'NHK語']

    # load_from_xml
    nhk_word_table.model.load_from_xml(@xml,
      :row_path => '*/nhk-word',
      :column_paths => ['id'])

    # assert row count
    assert_equal(2, nhk_word_table.model.row_count)

    # assert first row
    assert_equal("1", nhk_word_table.model.get_value_at(0, 0))
    assert_nil(nhk_word_table.model.get_value_at(0, 1))

    # assert second row
    assert_equal("2", nhk_word_table.model.get_value_at(1, 0))
    assert_nil(nhk_word_table.model.get_value_at(1, 1))
  end

  # less number of columns with refresh_columns
  def test_load_from_xml_less_number_of_columns_with_refresh_columns
    # Initialize JTable and model
    nhk_word_table = JTable.new
    nhk_word_table.model = ['ID', 'NHK語']

    # load_from_xml
    nhk_word_table.model.load_from_xml(@xml,
      :row_path => '*/nhk-word',
      :column_paths => ['id'], 
      :refresh_columns => true)

    # assert row count
    assert_equal(2, nhk_word_table.model.row_count)
    assert_equal(1, nhk_word_table.model.column_count)

    # assert first row
    assert_equal("1", nhk_word_table.model.get_value_at(0, 0))

    # assert second row
    assert_equal("2", nhk_word_table.model.get_value_at(1, 0))
  end

  # large number of columns
  def test_load_from_xml_large_number_of_columns
    # Initialize JTable and model
    nhk_word_table = JTable.new
    nhk_word_table.model = ['ID', 'NHK語']

    # load_from_xml
    nhk_word_table.model.load_from_xml(@xml,
      :row_path => '*/nhk-word',
      :column_paths => ['id', 'expression', 'created-at'])

    # assert row count
    assert_equal(2, nhk_word_table.model.row_count)
  end

  # large number of columns with refresh_columns
  def test_load_from_xml_large_number_of_columns_with_refresh_columns
    # Initialize JTable and model
    nhk_word_table = JTable.new
    nhk_word_table.model = ['ID', 'NHK語']

    # load_from_xml
    nhk_word_table.model.load_from_xml(@xml,
      :row_path => '*/nhk-word',
      :column_paths => ['id', 'expression', 'created-at'], 
      :refresh_columns => true)

    # assert row count
    assert_equal(2, nhk_word_table.model.row_count)
    assert_equal(3, nhk_word_table.model.column_count)

    # assert for normal
    assert_for_normal(nhk_word_table)

    # assert first row
    assert_equal("2008-08-13T20:35:00Z", nhk_word_table.model.get_value_at(0, 2))

    # assert second row
    assert_equal("2008-08-13T20:36:00Z", nhk_word_table.model.get_value_at(1, 2))
  end

  # insert_row
  def test_insert_row
    # Initialize JTable and model
    nhk_word_table = JTable.new
    nhk_word_table.model = ['ID', 'NHK語']

    # Insert Rows
    nhk_word_table.model.insert_row(0, [1, "いんさーと"])
    nhk_word_table.model.insert_row(0, [2, "インサートその2"])

    # assert row count
    assert_equal(2, nhk_word_table.model.row_count)

    # assert first row
    assert_equal(2, nhk_word_table.model.get_value_at(0, 0))
    assert_equal("インサートその2", nhk_word_table.model.get_value_at(0, 1))

    # assert second row
    assert_equal(1, nhk_word_table.model.get_value_at(1, 0))
    assert_equal("いんさーと", nhk_word_table.model.get_value_at(1, 1))
  end

  # add_row
  def test_add_row
    # Initialize JTable and model
    nhk_word_table = JTable.new
    nhk_word_table.model = ['ID', 'NHK語']

    # Insert Rows
    nhk_word_table.model.add_row([1, "いんさーと"])
    nhk_word_table.model.add_row([2, "インサートその2"])

    # assert row count
    assert_equal(2, nhk_word_table.model.row_count)

    # assert first row
    assert_equal(1, nhk_word_table.model.get_value_at(0, 0))
    assert_equal("いんさーと", nhk_word_table.model.get_value_at(0, 1))

    # assert second row
    assert_equal(2, nhk_word_table.model.get_value_at(1, 0))
    assert_equal("インサートその2", nhk_word_table.model.get_value_at(1, 1))
  end

  # new with 2d-Array
  def test_new_with_2dArray
    # Initialize JTable and model
    nhk_word_table = JTable.new
    nhk_word_table.model = [[1, "1行目"], [2, "2行目"], [3, "3行目"]]

    # assert row count
    assert_equal(3, nhk_word_table.model.row_count)

    # assert column count
    assert_equal(2, nhk_word_table.model.column_count)

    # assert rows
    for i in 1..nhk_word_table.model.row_count
      assert_equal(i, nhk_word_table.model.get_value_at((i-1), 0))
      assert_equal("#{i}行目", nhk_word_table.model.get_value_at((i-1), 1))
    end

    # assert columns
    for i in 1..nhk_word_table.model.column_count
      assert_equal(i.to_s, nhk_word_table.model.getColumnName(i-1))
    end
  end

  # new with Array
  def test_new_with_array
    # Initialize JTable and model
    nhk_word_table = JTable.new
    nhk_word_table.model = ["ID", "NHK語"]

    # assert row count
    assert_equal(0, nhk_word_table.model.row_count)

    # assert column count
    assert_equal(2, nhk_word_table.model.column_count)

    # assert columns
    assert_equal("ID", nhk_word_table.model.get_column_name(0))
    assert_equal("NHK語", nhk_word_table.model.get_column_name(1))
  end

  # new with Hash
  def test_new_with_hash_data_column_names
    # Initialize JTable and model
    nhk_word_table = JTable.new
    nhk_word_table.model = {:data => [["1", "ないわ～"], ["2", "格好いい"]], :column_names => ["ID", "NHK語"]}

    assert_for_normal(nhk_word_table)
  end

  # new with Hash
  def test_new_with_hash_rows_columns
    # Initialize JTable and model
    nhk_word_table = JTable.new
    nhk_word_table.model = {:rows => [["1", "ないわ～"], ["2", "格好いい"]], :columns => ["ID", "NHK語"]}

    assert_for_normal(nhk_word_table)
  end

  # new with Hash nil rows
  def test_new_with_hash_nil_rows
    # Initialize JTable and model
    nhk_word_table = JTable.new

    assert_raise(ArgumentError) do
      nhk_word_table.model = {:columns => ["ID", "NHK語"]}
    end
  end

  # new with Hash nil cols
  def test_new_with_hash_nil_cols
    # Initialize JTable and model
    nhk_word_table = JTable.new

    assert_raise(ArgumentError) do
      nhk_word_table.model = {:rows => [["1", "ないわ～"], ["2", "格好いい"]]}
    end
  end

  # new with XML
  def test_new_with_xml
    # Initialize JTable and model
    nhk_word_table = JTable.new
    nhk_word_table.model = DefaultTableModel.new(@xml, {:row_path => '*/nhk-word', :column_paths => ['id', 'expression']})

    assert_for_normal(nhk_word_table)
  end

  # new with original constructor
  def test_new_with_original_constructor
    # Initialize JTable and model
    nhk_word_table = JTable.new
    nhk_word_table.model = DefaultTableModel.new(4, 3)

    # assert row count
    assert_equal(4, nhk_word_table.model.row_count)

    # assert column count
    assert_equal(3, nhk_word_table.model.column_count)

    # assert cells
    for i in 1..nhk_word_table.model.row_count
      for j in 1..nhk_word_table.model.column_count
        assert_nil(nhk_word_table.model.get_value_at((i-1), (j-1)))
      end
    end
  end
end
