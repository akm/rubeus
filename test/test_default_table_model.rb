# -*- coding: utf-8 -*-
require 'test/unit'
require 'rubygems'
require 'rubeus'
require 'rexml/document'

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
		assert_equal("ないわ〜", nhk_word_table.model.get_value_at(0, 1))

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
		nhk_word_table.model.load_from_xml(@xml,
			:row_path => '*/nhk-word',
			:column_paths => ['ida', 'expression'])

		# assert row count
		assert_equal(2, nhk_word_table.model.row_count)
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
end
