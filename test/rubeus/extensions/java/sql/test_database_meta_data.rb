require 'test/unit'
require 'rubygems'
require 'rubeus'
require 'test/rubeus/extensions/java/sql/test_sql_helper'

# Test for lib/rubeus/extensions/java/sql/database_meta_data.rb
class TestDatabaseMetaData < Test::Unit::TestCase
  include TestSqlHelper

  def setup
    setup_connection
    @con.statement do |stmt|
      drop_table_if_exist("TEST", stmt)
      # DDL from http://db.apache.org/derby/docs/dev/ja_JP/ref/rrefsqlj13590.html
      create_table_after_drop(<<-"EOS", stmt)
        CREATE TABLE FLIGHTS
          (
          FLIGHT_ID CHAR(6) NOT NULL ,
          SEGMENT_NUMBER INTEGER NOT NULL ,
          ORIG_AIRPORT CHAR(3),
          DEPART_TIME TIME,
          DEST_AIRPORT CHAR(3),
          ARRIVE_TIME TIME,
          MEAL CHAR(1) CONSTRAINT MEAL_CONSTRAINT 
          CHECK (MEAL IN ('B', 'L', 'D', 'S')),
          PRIMARY KEY (FLIGHT_ID, SEGMENT_NUMBER)
          );
        CREATE TABLE FLTAVAIL
          (
          FLIGHT_ID CHAR(6) NOT NULL, 
          SEGMENT_NUMBER INT NOT NULL, 
          FLIGHT_DATE DATE NOT NULL, 
          ECONOMY_SEATS_TAKEN INT,
          BUSINESS_SEATS_TAKEN INT,
          FIRSTCLASS_SEATS_TAKEN INT, 
          CONSTRAINT FLTAVAIL_PK PRIMARY KEY (FLIGHT_ID, SEGMENT_NUMBER), 
          CONSTRAINT FLTS_FK
          FOREIGN KEY (FLIGHT_ID, SEGMENT_NUMBER)
          REFERENCES Flights (FLIGHT_ID, SEGMENT_NUMBER)
          );
      EOS
      create_table_after_drop(<<-"EOS", stmt)
        CREATE TABLE CITIES
          (
          ID INT NOT NULL CONSTRAINT CITIES_PK PRIMARY KEY,
          CITY_NAME VARCHAR(50)
          );
        CREATE TABLE METROPOLITAN
          (
          HOTEL_ID INT NOT NULL CONSTRAINT HOTELS_PK PRIMARY KEY,
          HOTEL_NAME VARCHAR(40) NOT NULL,
          CITY_ID INT CONSTRAINT METRO_FK REFERENCES CITIES
          );
      EOS
    end
  end
  
  def teardown
    teardown_connection
  end

  def test_table_objects
    tables = @con.meta_data.table_objects(nil, "APP", nil, :name_case => :downcase)
    assert_equal 4, tables.length
    assert_equal ['cities', 'flights', 'fltavail', 'metropolitan'], tables.map{|t|t.name}.sort
    assert_not_nil flights = tables['flights']
    assert_not_nil fltavail = tables['fltavail']
    assert_not_nil ctiies = tables['cities']
    assert_not_nil metropolitan = tables['metropolitan']
  rescue => e
    puts e.to_s
    puts e.backtrace.join("\n  ")
     raise e
  end
  
  def assert_column(table, name, type, size, nullable)
    column = table.columns[name]
    assert_not_nil column, "column '#{name}' not found"
    assert_equal java.sql.Types.const_get(type.to_s.upcase), column.data_type, "column '#{name}' type expected #{java.sql.Types.const_get(type.to_s.upcase).inspect} but #{column.data_type.inspect}"
    assert_equal size, column.size, "column '#{name}' size expected #{size.inspect} but #{column.size.inspect}"
    assert_equal nullable, column.nullable?, "column '#{name}' nullable expected #{nullable.inspect} but #{column.nullable?.inspect}"
    assert_equal nullable ? java.sql.DatabaseMetaData.columnNullable : java.sql.DatabaseMetaData.columnNoNulls, column.nullable
  end
  
  def test_test_table_object_columns
    tables = @con.meta_data.table_objects(nil, "APP", nil, :name_case => :downcase)
    assert_equal 4, tables.length
    table_hash = tables.inject({}){|d, t| d[t.name] = t; d}
    #
    assert_not_nil flights = table_hash['flights']
    assert_equal 7, flights.columns.length
    assert_column(flights, 'flight_id', :char, 6, false)
    assert_column(flights, 'segment_number', :integer, 10, false)
    assert_column(flights, 'orig_airport', :char, 3, true)
    assert_column(flights, 'depart_time', :time, 8, true)
    assert_column(flights, 'dest_airport', :char, 3, true)
    assert_column(flights, 'arrive_time', :time, 8, true)
    assert_column(flights, 'meal', :char, 1, true)
    #
    assert_not_nil fltavail = table_hash['fltavail']
    assert_equal 6, fltavail.columns.length
    assert_column(fltavail, 'flight_id', :char, 6, false)
    assert_column(fltavail, 'segment_number', :integer, 10, false)
    assert_column(fltavail, 'flight_date', :date, 10, false)
    assert_column(fltavail, 'economy_seats_taken', :integer, 10, true)
    assert_column(fltavail, 'business_seats_taken', :integer, 10, true)
    assert_column(fltavail, 'firstclass_seats_taken', :integer, 10, true)
    #
    assert_not_nil ctiies = table_hash['cities']
    assert_equal 2, ctiies.columns.length
    assert_column(ctiies, 'id', :integer, 10, false)
    assert_column(ctiies, 'city_name', :varchar, 50, true)
    #
    assert_not_nil metropolitan = table_hash['metropolitan']
    assert_equal 3, metropolitan.columns.length
    assert_column(metropolitan, 'hotel_id', :integer, 10, false)
    assert_column(metropolitan, 'hotel_name', :varchar, 40, false)
    assert_column(metropolitan, 'city_id', :integer, 10, true)
  rescue => e
    puts e.to_s
    puts e.backtrace.join("\n  ")
    raise e
  end
  
end

