require 'test/unit'
require 'rubygems'
require 'rubeus'
require File.expand_path('../../rubeus_test.jar', File.dirname(__FILE__))

Rubeus.verbose = true

class TestMethodModifier < Test::Unit::TestCase
  include Rubeus::Reflection

  VariousMethods = jp.rubybizcommons.rubeus.test.reflection.VariousMethods

  def test_static?
    [java.lang.String, java.lang.Object, java.lang.Class, VariousMethods].each do |klass|
      klass.java_class.java_class_methods.each do |m|
        assert_equal true, m.static?
      end
      klass.java_class.java_instance_methods.each do |m|
        assert_equal false, m.static?
      end
    end
  end

  def test_abstract?
    m = java.util.AbstractList.java_class.java_instance_methods.detect{|m| m.name == "get"}
    assert_equal true, m.abstract?
    m = java.util.AbstractList.java_class.java_instance_methods.detect{|m| m.name == "add"}
    assert_equal false, m.abstract?
  end

  ALL_METHOD_NAMES = %w[main
     staticPublicStrictfp staticProtectedFinal staticPackageSynchronized staticPrivate
     publicStrictfp protectedFinal packageSynchronized privateFinal]

  def test_public?
    each_java_methods do |m|
      assert_equal %w[main staticPublicStrictfp publicStrictfp].include?(m.name), m.public?
    end
  end

  def test_protected?
    each_java_methods do |m|
      assert_equal %w[staticProtectedFinal protectedFinal].include?(m.name), m.protected?
    end
  end

  def test_package_scope?
    each_java_methods do |m|
      assert_equal %w[staticPackageSynchronized packageSynchronized].include?(m.name), m.package_scope?
    end
  end

  def test_private?
    each_java_methods do |m|
      assert_equal %w[staticPrivate privateFinal].include?(m.name), m.private?
    end
  end

  def test_final?
    each_java_methods do |m|
      assert_equal %w[staticProtectedFinal protectedFinal privateFinal].include?(m.name), m.final?
    end
  end

  def test_strict?
    each_java_methods do |m|
      assert_equal %w[main staticPublicStrictfp publicStrictfp].include?(m.name), m.public?
    end
  end

  def test_synchronized?
    each_java_methods do |m|
      assert_equal %w[staticPackageSynchronized packageSynchronized].include?(m.name), m.synchronized?
    end
  end

  private

  def each_java_methods(&block)
    unless @test_methods
      selector = lambda{|m| ALL_METHOD_NAMES.include?(m.name)}
      @test_methods =
        VariousMethods.java_class.java_instance_methods.select(&selector) +
        VariousMethods.java_class.java_class_methods.select(&selector)
    end
    @test_methods.each(&block)
  end

end
