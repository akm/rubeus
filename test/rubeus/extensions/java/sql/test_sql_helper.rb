require 'minitest_helper'

module TestSqlHelper
  def setup_connection
    @con = Rubeus::Jdbc::DriverManager.connect("jdbc:derby:test_db;create = true", "", "")
  end

  def teardown_connection
    @con.close
  end

  def close_if_no_statement(statement = nil)
    must_be_closed = statement.nil?
    statement ||= @con.create_statement
    begin
      yield(statement)
    ensure
      statement.close if must_be_closed
    end
  end

  def drop_table_if_exist(table_name, statement = nil)
    close_if_no_statement(statement) do |stmt|
      begin
        stmt.execute_update("DROP TABLE #{table_name}")
      rescue
        # the table doesn't exist but do nothing
      end
    end
  end

  def create_table_after_drop(create_ddl, statement = nil)
    create_ddls = create_ddl.split(/\;/mi).map{|ddl| ddl.strip }.select{|ddl| !(ddl.nil? || ddl.empty?) }
    table_names = create_ddls.map{|ddl| ddl.scan(/^\s*CREATE TABLE\s+?(.+?)[\s\($]/mi)}
    close_if_no_statement(statement) do |stmt|
      table_names.reverse.each do |table_name|
        drop_table_if_exist(table_name, stmt)
      end
      create_ddls.each do |ddl|
        stmt.execute_update(ddl)
      end
    end
  end

end
