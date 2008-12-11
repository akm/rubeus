module TestSqlHelper
  def setup_connection
    @con = Rubeus::Jdbc::DriverManager.connect("jdbc:derby:test_db;create = true", "", "")
  end

  def teardown_connection
    @con.close
  end
  
  def create_table_after_drop(create_ddl, stmt = nil)
    table_name = create_ddl.scan(/^CREATE TABLE\s+?(.+?)\s+/i)
    must_be_closed = stmt.nil?
    stmt ||= @con.create_statement
    begin
      begin
        stmt.execute_update("DROP TABLE #{table_name}")
      rescue
        # the table doesn't exist but do nothing
      end
      stmt.execute_update(create_ddl)
    ensure
      stmt.close if must_be_closed
    end
  end
  
end
