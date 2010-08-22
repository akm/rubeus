require 'test/unit'
require 'rubygems'
require 'rubeus'
# gem "activesupport"
require 'active_support/test_case'
require 'test/rubeus/extensions/java/sql/test_sql_helper'

# Test for lib/rubeus/extensions/java/sql/database_meta_data.rb
class TestDatabaseMetaData < ActiveSupport::TestCase
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
    tables = @con.meta_data.tables(:schema => "APP", :name_case => :downcase)
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

  def test_table_inspect_with_downcase
    tables = @con.meta_data.tables(:schema => "APP", :name_case => :downcase)
    assert_equal "#<Rubeus::Jdbc::Table flights(flight_id,segment_number,orig_airport,depart_time,dest_airport,arrive_time,meal)>", tables['flights'].inspect
    assert_equal "#<Rubeus::Jdbc::Table fltavail(flight_id,segment_number,flight_date,economy_seats_taken,business_seats_taken,firstclass_seats_taken)>", tables['fltavail'].inspect
    assert_equal "#<Rubeus::Jdbc::Table cities(id,city_name)>", tables['cities'].inspect
    assert_equal "#<Rubeus::Jdbc::Table metropolitan(hotel_id,hotel_name,city_id)>", tables['metropolitan'].inspect
    assert_equal "#<Rubeus::Jdbc::Table test1(id,name)>", tables['test1'].inspect
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
    tables = @con.meta_data.tables(:schema => "APP", :name_case => :downcase)
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
    assert_equal "#<Rubeus::Jdbc::Column flight_id CHAR(6) NOT NULL>", flights.columns["flight_id"].inspect
    assert_equal "#<Rubeus::Jdbc::Column segment_number INTEGER(10) NOT NULL>", flights.columns["segment_number"].inspect
    assert_equal "#<Rubeus::Jdbc::Column orig_airport CHAR(3) NULL>", flights.columns["orig_airport"].inspect
    assert_equal "#<Rubeus::Jdbc::Column depart_time TIME(8) NULL>", flights.columns["depart_time"].inspect
    assert_equal "#<Rubeus::Jdbc::Column dest_airport CHAR(3) NULL>", flights.columns["dest_airport"].inspect
    assert_equal "#<Rubeus::Jdbc::Column arrive_time TIME(8) NULL>", flights.columns["arrive_time"].inspect
    assert_equal "#<Rubeus::Jdbc::Column meal CHAR(1) NULL>", flights.columns["meal"].inspect
    #
    assert_not_nil fltavail = tables['fltavail']
    assert_equal 6, fltavail.columns.length
    assert_column(fltavail, 'flight_id', :char, 6, false)
    assert_column(fltavail, 'segment_number', :integer, 10, false)
    assert_column(fltavail, 'flight_date', :date, 10, false)
    assert_column(fltavail, 'economy_seats_taken', :integer, 10, true)
    assert_column(fltavail, 'business_seats_taken', :integer, 10, true)
    assert_column(fltavail, 'firstclass_seats_taken', :integer, 10, true)
    assert_equal "#<Rubeus::Jdbc::Column flight_id CHAR(6) NOT NULL>", fltavail.columns["flight_id"].inspect
    assert_equal "#<Rubeus::Jdbc::Column segment_number INTEGER(10) NOT NULL>", fltavail.columns["segment_number"].inspect
    assert_equal "#<Rubeus::Jdbc::Column flight_date DATE(10) NOT NULL>", fltavail.columns["flight_date"].inspect
    assert_equal "#<Rubeus::Jdbc::Column economy_seats_taken INTEGER(10) NULL>", fltavail.columns["economy_seats_taken"].inspect
    assert_equal "#<Rubeus::Jdbc::Column business_seats_taken INTEGER(10) NULL>", fltavail.columns["business_seats_taken"].inspect
    assert_equal "#<Rubeus::Jdbc::Column firstclass_seats_taken INTEGER(10) NULL>", fltavail.columns["firstclass_seats_taken"].inspect
    #
    assert_not_nil ctiies = tables['cities']
    assert_equal 2, ctiies.columns.length
    assert_column(ctiies, 'id', :integer, 10, false)
    assert_column(ctiies, 'city_name', :varchar, 50, true)
    assert_equal "#<Rubeus::Jdbc::Column id INTEGER(10) NOT NULL>", ctiies.columns["id"].inspect
    assert_equal "#<Rubeus::Jdbc::Column city_name VARCHAR(50) NULL>", ctiies.columns["city_name"].inspect
    #
    assert_not_nil metropolitan = tables['metropolitan']
    assert_equal 3, metropolitan.columns.length
    assert_column(metropolitan, 'hotel_id', :integer, 10, false)
    assert_column(metropolitan, 'hotel_name', :varchar, 40, false)
    assert_column(metropolitan, 'city_id', :integer, 10, true)
    assert_equal "#<Rubeus::Jdbc::Column hotel_id INTEGER(10) NOT NULL>", metropolitan.columns["hotel_id"].inspect
    assert_equal "#<Rubeus::Jdbc::Column hotel_name VARCHAR(40) NOT NULL>", metropolitan.columns["hotel_name"].inspect
    assert_equal "#<Rubeus::Jdbc::Column city_id INTEGER(10) NULL>", metropolitan.columns["city_id"].inspect
    #
    assert_not_nil test1 = tables['test1']
    assert_equal 2, test1.columns.length
    assert_column(test1, 'id', :integer, 10, false)
    assert_column(test1, 'name', :varchar, 60, true)
    assert_equal "#<Rubeus::Jdbc::Column id INTEGER(10) NOT NULL>", test1.columns["id"].inspect
    assert_equal "#<Rubeus::Jdbc::Column name VARCHAR(60) NULL>", test1.columns["name"].inspect
  rescue => e
    puts e.to_s
    puts e.backtrace.join("\n  ")
    raise e
  end

  def assert_pk(table, names)
    assert_equal names, table.pk_names
    assert_equal names, table.primary_key_names
    names.each_with_index do |name, index|
      assert_equal table.columns[name], table.primary_key.columns[index]
      assert_equal table.columns[name], table.primary_key.columns[name]
      assert_equal table.columns[name], table.primary_key_columns[index]
      assert_equal table.columns[name], table.primary_key_columns[name]
      assert_equal table.columns[name], table.pk_columns[index]
      assert_equal table.columns[name], table.pk_columns[name]
      assert_equal name, table.primary_key[index]
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
      assert_equal table.pk_names.first, table.pk_name
      assert_equal table.pk_names.first, table.primary_key_name
      assert_equal table.pk_columns.first, table.pk_column
      assert_equal table.pk_columns.first, table.primary_key_column
    else
      assert_equal table.pk_names, table.pk_name
      assert_equal table.pk_names, table.primary_key_name
      assert_equal table.pk_columns, table.pk_column
      assert_equal table.pk_columns, table.primary_key_column
    end
    if names.length > 0
      assert_equal names.length, table.primary_key.length
      assert_equal names, table.primary_key.column_names
      assert_equal names, table.pk.column_names
      assert_equal "#<Rubeus::Jdbc::PrimaryKey #{table.name}(#{names.join(',')})>", table.primary_key.inspect
    end
    table.columns.each do |column|
      if table.pk_names.include?(column.name)
        assert_equal true, column.primary_key?, "#{table.name}.#{column.name} shoud be one of pk"
        assert_equal true, column.pk?, "#{table.name}.#{column.name} shoud be one of pk"
      else
        assert_equal false, column.primary_key?, "#{table.name}.#{column.name} shoud not be one of pk"
        assert_equal false, column.pk?, "#{table.name}.#{column.name} shoud not be one of pk"
      end
    end
  end

  def test_table_objects_pk
    tables = @con.meta_data.tables(:schema => "APP", :name_case => :downcase)
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
    tables = @con.meta_data.tables(:schema => "APP", :name_case => :downcase)
    # assert_equal %w(idx_flight_01 idx_flight_02 idx_flight_03), tables['flights'].indexes.map{|idx| idx.name}
    # assert_equal 3, tables['flights'].indexes.length
    t = tables['flights']
    assert_index(t, 'idx_flight_01', %w(orig_airport), [true])
    assert_index(t, 'idx_flight_02', %w(orig_airport depart_time), [true, false])
    assert_index(t, 'idx_flight_03', %w(dest_airport arrive_time), [true, false])
    assert_equal "#<Rubeus::Jdbc::Index flights.idx_flight_01(orig_airport)>", t.indexes['idx_flight_01'].inspect
    assert_equal "#<Rubeus::Jdbc::Index flights.idx_flight_02(orig_airport,depart_time DESC)>", t.indexes['idx_flight_02'].inspect
    assert_equal "#<Rubeus::Jdbc::Index flights.idx_flight_03(dest_airport,arrive_time DESC)>", t.indexes['idx_flight_03'].inspect

    # assert_equal 0, tables['fltavail'].indexes.length

    # assert_equal 1, tables['cities'].indexes.length
    assert_index(tables['cities'], 'idx_cities_01', %w(city_name), [true])
    assert_equal "#<Rubeus::Jdbc::Index cities.idx_cities_01(city_name)>", tables['cities'].indexes['idx_cities_01'].inspect

    # assert_equal 1, tables['metropolitan'].indexes.length
    assert_index(tables['metropolitan'], 'idx_metropolitan_01', %w(city_id hotel_name), [true, true])
    assert_equal "#<Rubeus::Jdbc::Index metropolitan.idx_metropolitan_01(city_id,hotel_name)>", tables['metropolitan'].indexes['idx_metropolitan_01'].inspect

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
    tables = @con.meta_data.tables(:schema => "APP", :name_case => :downcase)
    assert_fk('flts_fk',
      tables['flights'], %w(flight_id segment_number),
      tables['fltavail'], %w(flight_id segment_number))
    assert_equal("#<Rubeus::Jdbc::ForeignKey flts_fk fltavail(flight_id,segment_number)=>flights(flight_id,segment_number)>",
      tables['fltavail'].foreign_keys['flts_fk'].inspect)

    assert_fk('metro_fk',
      tables['cities'], %w(id),
      tables['metropolitan'], %w(city_id))
    assert_equal("#<Rubeus::Jdbc::ForeignKey metro_fk metropolitan(city_id)=>cities(id)>",
      tables['metropolitan'].foreign_keys['metro_fk'].inspect)
  end

end
