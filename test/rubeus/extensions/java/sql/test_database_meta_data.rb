require 'test/unit'
require 'rubygems'
require 'rubeus'
require 'test/rubeus/extensions/java/sql/test_sql_helper'

# Test for connetion.rb
class TestDatabaseMetaData < Test::Unit::TestCase
  include TestSqlHelper

  def setup
    setup_connection
  end
  
  def teardown
    teardown_connection
  end

  def test_table_objects
    @con.statement do |stmt|
      create_table_after_drop("CREATE TABLE USERS (ID INT, NAME CHAR(10))", stmt)
      create_table_after_drop("CREATE TABLE EMAILS (ID INT, ADDRESS CHAR(200), USER_ID INT)", stmt)
    end
    tables = @con.meta_data.table_objects(nil, nil, nil, :name_case => :downcase)
    assert_equal 2, tables.length
    table_hash = tables.inject({}){|d, t| d[t.name] = t; d}
    assert_not_nil users = table_hash['users']
    assert_not_nil emails = table_hash['emails']
    assert_length 2, users.columns.length
    assert_length 3, emails.columns.length
  rescue => e
    puts e.to_s
    puts e.backtrace.join("\n  ")
    raise e
  end
end

