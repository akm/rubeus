# -*- coding: utf-8 -*-
require 'rubygems'
require 'rubeus'

class JdbcExample
  # includeしててもOKだけど、参照するのは基本DriverManagerしかないので、
  # DriverManager => Rubeus::Jdbc::DriverManager を使うようにすればOK
  # include Rubeus::Jdbc

  def test
    Rubeus::Jdbc::DriverManager.connect("jdbc:derby:testdb;create = true", "", "") do |con|
      con.statement do |stmt|
        # Drop table TEST if exists
        begin
          stmt.execute_update("DROP TABLE TEST")
        rescue
          # ignore error if table not exist
        end

        # Setup table and data
        stmt.execute_update("CREATE TABLE TEST(id int, data char(10))")
        stmt.execute_update("INSERT INTO TEST VALUES(1, 'first')")
        stmt.execute_update("INSERT INTO TEST VALUES(2, 'second')")

        # Query
        stmt.query("SELECT * FROM TEST") do |rs|
          rs.each do |rsNext|
            print "|", rsNext.getInt("ID"), "|", rsNext.getString("DATA"), "|\n"
          end
        end

        # Query by each_array
        stmt.query("SELECT * FROM TEST") do |rs|
          rs.each_array do |rsNext|
            print "|", rsNext[0], "|", rsNext[1], "|\n"
          end
        end

        # Connection#query by each_hash
        con.query("SELECT * FROM TEST") do |rs|
          rs.each_hash do |rsNext|
            print "|", rsNext["ID"], "|", rsNext["DATA"], "|\n"
          end
        end

      end
    end
  end
end

JdbcExample.new.test
