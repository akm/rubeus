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
      # Index from http://db.apache.org/derby/docs/dev/ja_JP/ref/rrefsqlj20937.html
      create_table_after_drop(<<-"EOS", stmt)
        CREATE TABLE FLIGHTS(
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
        CREATE TABLE FLTAVAIL(
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
      stmt.execute_update('CREATE INDEX IDX_FLIGHT_01 ON Flights(orig_airport)')
      stmt.execute_update('CREATE INDEX IDX_FLIGHT_02 ON Flights(orig_airport, DEPART_TIME desc)')
      stmt.execute_update('CREATE INDEX IDX_FLIGHT_03 ON Flights(DEST_AIRPORT, ARRIVE_TIME desc)')
      create_table_after_drop(<<-"EOS", stmt)
        CREATE TABLE CITIES(
          ID INT NOT NULL CONSTRAINT CITIES_PK PRIMARY KEY,
          CITY_NAME VARCHAR(50)
          );
        CREATE TABLE METROPOLITAN(
          HOTEL_ID INT NOT NULL CONSTRAINT HOTELS_PK PRIMARY KEY,
          HOTEL_NAME VARCHAR(40) NOT NULL,
          CITY_ID INT CONSTRAINT METRO_FK REFERENCES CITIES
          );
      EOS
      stmt.execute_update('CREATE UNIQUE INDEX IDX_CITIES_01 ON CITIES(CITY_NAME)')
      stmt.execute_update('CREATE UNIQUE INDEX IDX_METROPOLITAN_01 ON METROPOLITAN(CITY_ID, HOTEL_NAME)')
      create_table_after_drop(<<-"EOS", stmt)
        CREATE TABLE TEST1(
          ID INT NOT NULL,
          NAME VARCHAR(60)
          );
      EOS
    end
  end
  
  def teardown
    teardown_connection
  end

  def test_table_objects
    tables = @con.meta_data.table_objects(nil, "APP", nil, :name_case => :downcase)
    assert_equal 5, tables.length
    assert_equal ['cities', 'flights', 'fltavail', 'metropolitan', 'test1'], tables.map{|t|t.name}.sort
    assert_not_nil tables['flights']
    assert_not_nil tables['fltavail']
    assert_not_nil tables['cities']
    assert_not_nil tables['metropolitan']
    assert_not_nil tables['test1']
  rescue => e
    puts e.to_s
    puts e.backtrace.join("\n  ")
     raise e
  end
  
  def assert_column(table, name, type, size, nullable)
    column = table.columns[name]
    assert_not_nil column, "column '#{name}' not found"
    assert_equal(java.sql.Types.const_get(type.to_s.upcase), column.data_type, 
      "column '#{name}' type expected #{java.sql.Types.const_get(type.to_s.upcase).inspect} but #{column.data_type.inspect}")
    assert_equal(size, column.size, 
      "column '#{name}' size expected #{size.inspect} but #{column.size.inspect}")
    assert_equal(nullable, column.nullable?, 
      "column '#{name}' nullable expected #{nullable.inspect} but #{column.nullable?.inspect}")
    assert_equal(nullable ? 
      java.sql.DatabaseMetaData.columnNullable : 
      java.sql.DatabaseMetaData.columnNoNulls, column.nullable)
    assert_equal column, table[name]
  end
  
  def test_table_object_columns
    tables = @con.meta_data.table_objects(nil, "APP", nil, :name_case => :downcase)
    #
    assert_not_nil flights = tables['flights']
    assert_equal 7, flights.columns.length
    assert_column(flights, 'flight_id', :char, 6, false)
    assert_column(flights, 'segment_number', :integer, 10, false)
    assert_column(flights, 'orig_airport', :char, 3, true)
    assert_column(flights, 'depart_time', :time, 8, true)
    assert_column(flights, 'dest_airport', :char, 3, true)
    assert_column(flights, 'arrive_time', :time, 8, true)
    assert_column(flights, 'meal', :char, 1, true)
    #
    assert_not_nil fltavail = tables['fltavail']
    assert_equal 6, fltavail.columns.length
    assert_column(fltavail, 'flight_id', :char, 6, false)
    assert_column(fltavail, 'segment_number', :integer, 10, false)
    assert_column(fltavail, 'flight_date', :date, 10, false)
    assert_column(fltavail, 'economy_seats_taken', :integer, 10, true)
    assert_column(fltavail, 'business_seats_taken', :integer, 10, true)
    assert_column(fltavail, 'firstclass_seats_taken', :integer, 10, true)
    #
    assert_not_nil ctiies = tables['cities']
    assert_equal 2, ctiies.columns.length
    assert_column(ctiies, 'id', :integer, 10, false)
    assert_column(ctiies, 'city_name', :varchar, 50, true)
    #
    assert_not_nil metropolitan = tables['metropolitan']
    assert_equal 3, metropolitan.columns.length
    assert_column(metropolitan, 'hotel_id', :integer, 10, false)
    assert_column(metropolitan, 'hotel_name', :varchar, 40, false)
    assert_column(metropolitan, 'city_id', :integer, 10, true)
    #
    assert_not_nil test1 = tables['test1']
    assert_equal 2, test1.columns.length
    assert_column(test1, 'id', :integer, 10, false)
    assert_column(test1, 'name', :varchar, 60, true)
  rescue => e
    puts e.to_s
    puts e.backtrace.join("\n  ")
    raise e
  end
  
  def assert_pk(table, names)
    assert_equal names.length, table.primary_keys.length
    assert_equal names, table.pks.map{|k| k.name}
    assert_equal names, table.primary_keys.map{|k| k.name}
    assert_equal names, table.pk_names
    assert_equal names, table.primary_key_names
    names.each_with_index do |name, index|
      assert_equal name, table.primary_keys[name].name
      assert_equal index + 1, table.primary_keys[name].seq
      assert_equal table.columns[name], table.primary_key_columns[name]
      assert_equal table.columns[name], table.pk_columns[name]
    end
    case names.length
    when 0
      assert_equal nil, table.pk
      assert_equal nil, table.primary_key
      assert_equal nil, table.pk_name
      assert_equal nil, table.primary_key_name
      assert_equal nil, table.pk_column
      assert_equal nil, table.primary_key_column
    when 1
      assert_equal table.pks.first, table.pk
      assert_equal table.pks.first, table.primary_key
      assert_equal table.pk_names.first, table.pk_name
      assert_equal table.pk_names.first, table.primary_key_name
      assert_equal table.pk_columns.first, table.pk_column
      assert_equal table.pk_columns.first, table.primary_key_column
    else
      assert_equal table.pks, table.pk
      assert_equal table.pks, table.primary_key
      assert_equal table.pk_names, table.pk_name
      assert_equal table.pk_names, table.primary_key_name
      assert_equal table.pk_columns, table.pk_column
      assert_equal table.pk_columns, table.primary_key_column
    end
  end
  
  def test_table_objects_pk
    tables = @con.meta_data.table_objects(nil, "APP", nil, :name_case => :downcase)
    assert_pk(tables['flights'], %w(flight_id segment_number))
    assert_pk(tables['fltavail'], %w(flight_id segment_number))
    assert_pk(tables['cities'], %w(id))
    assert_pk(tables['metropolitan'], %w(hotel_id))
    assert_pk(tables['test1'], [])
  end
  
  def assert_index(table, index_name, key_names, asc_descs)
    assert_equal key_names, table.indexes[index_name].keys.map{|k| k.name}
    assert_equal asc_descs, table.indexes[index_name].keys.map{|k| k.asc?}
  end
  
  def test_table_objects_index
    tables = @con.meta_data.table_objects(nil, "APP", nil, :name_case => :downcase)
    # assert_equal %w(idx_flight_01 idx_flight_02 idx_flight_03), tables['flights'].indexes.map{|idx| idx.name}
    # assert_equal 3, tables['flights'].indexes.length
    assert_index(tables['flights'], 'idx_flight_01', %w(orig_airport), [true])
    assert_index(tables['flights'], 'idx_flight_02', %w(orig_airport depart_time), [true, false])
    assert_index(tables['flights'], 'idx_flight_03', %w(dest_airport arrive_time), [true, false])
    # assert_equal 0, tables['fltavail'].indexes.length
    
    # assert_equal 1, tables['cities'].indexes.length
    assert_index(tables['cities'], 'idx_cities_01', %w(city_name), [true])
    # assert_equal 1, tables['metropolitan'].indexes.length
    assert_index(tables['metropolitan'], 'idx_metropolitan_01', %w(city_id hotel_name), [true, true])

    # assert_equal 0, tables['test1'].indexes.length
  end
  
  def assert_fk(fk_name, pktable, pkcolumn_names, fktable, fkcolumn_names)
    imported_key = fktable.imported_keys[fk_name]
    exported_key = pktable.exported_keys[fk_name]
    assert_equal fk_name, imported_key.name
    assert_equal fk_name, exported_key.name
    
    assert_equal pktable.name, imported_key.pktable.name
    assert_equal fktable.name, imported_key.fktable.name
    assert_equal pktable.name, exported_key.pktable.name
    assert_equal fktable.name, exported_key.fktable.name
    
    assert_equal pkcolumn_names.length, imported_key.length
    assert_equal fkcolumn_names.length, exported_key.length
    assert_equal imported_key.length, exported_key.length

    pkcolumn_names.each_with_index do |column_name, index|
      [imported_key, exported_key].each do |key|
        assert_equal pkcolumn_names[index], key.pkcolumn_names[index]
        assert_equal pkcolumn_names[index], key.pkcolumns[index].name
        assert_equal pktable, key.pkcolumns[index].table
        assert_equal fkcolumn_names[index], key.fkcolumn_names[index]
        assert_equal fkcolumn_names[index], key.fkcolumns[index].name
        assert_equal fktable, key.fkcolumns[index].table
      end
    end
  end
  
  def test_table_objects_imported_keys_and_exported_keys
    tables = @con.meta_data.table_objects(nil, "APP", nil, :name_case => :downcase)
    assert_fk('flts_fk', 
      tables['flights'], %w(flight_id segment_number),
      tables['fltavail'], %w(flight_id segment_number))
    assert_fk('metro_fk', 
      tables['cities'], %w(id),
      tables['metropolitan'], %w(city_id))
  end
  
end
