require File.expand_path('../../test_helper', File.dirname(__FILE__))
require File.expand_path('../../rubeus_test.jar', File.dirname(__FILE__))

class TestJavaMethods < Test::Unit::TestCase
  include Rubeus::Reflection

  def test_ruby_string_java_methods
    assert_nil String.java_methods
    assert_nil "".java_methods
  end

  def test_java_string_java_class_methods
    expected_methods = %w[copyValueOf format valueOf]
    assert_equal expected_methods, java.lang.String.java_methods.sort
    assert_equal expected_methods, java.lang.String.java_class_methods.sort
    assert_equal expected_methods, java.lang.String.java_singleton_methods.sort
  end

  def test_java_string_java_instance_methods
    expected_methods = %w[charAt codePointAt codePointBefore codePointCount
      compareTo compareToIgnoreCase concat contains contentEquals endsWith
      equals equalsIgnoreCase getBytes getChars getClass hashCode indexOf
      intern isEmpty lastIndexOf length matches notify notifyAll
      offsetByCodePoints regionMatches replace replaceAll replaceFirst
      split startsWith subSequence substring toCharArray toLowerCase
      toString toUpperCase trim wait]
    assert_equal expected_methods, java.lang.String.java_instance_methods.sort
    assert_equal expected_methods, java.lang.String.new("").java_methods.sort
  end


  VariousMethods = jp.rubybizcommons.rubeus.test.reflection.VariousMethods

  def test_public_class_methods
    assert_equal %w[main staticPublicStrictfp], VariousMethods.java_class.java_public_methods.map(&:name)
    assert_equal %w[main staticPublicStrictfp], VariousMethods.java_class.java_public_class_methods.map(&:name)
    VariousMethods.java_class.java_public_methods.each{|java_method| assert java_method.public?}
    VariousMethods.java_class.java_public_class_methods.each{|java_method| assert java_method.public?}
  end

  def test_public_instance_methods
    assert_equal(%w[publicStrictfp],
      (VariousMethods.java_class.java_public_instance_methods.map(&:name) -
        java.lang.Object.java_class.java_public_instance_methods.map(&:name)))
    VariousMethods.java_class.java_public_instance_methods.each{|java_method| assert java_method.public?}
  end

  def test_protected_class_methods
    assert_equal 1, VariousMethods.java_class.java_protected_methods.length
    VariousMethods.java_class.java_protected_methods.each{|java_method| assert java_method.protected?}
    VariousMethods.java_class.java_protected_class_methods.each{|java_method| assert java_method.protected?}
    assert_equal %w[staticProtectedFinal], VariousMethods.java_class.java_protected_methods.map(&:name)
    assert_equal %w[staticProtectedFinal], VariousMethods.java_class.java_protected_class_methods.map(&:name)
  end

  def test_protected_instance_methods
    assert_equal(%w[protectedFinal],
      (VariousMethods.java_class.java_protected_instance_methods.map(&:name) -
        java.lang.Object.java_class.java_protected_instance_methods.map(&:name)))
    VariousMethods.java_class.java_protected_instance_methods.each{|java_method| assert java_method.protected?}
  end

  def test_package_scope_class_methods
    assert_equal 1, VariousMethods.java_class.java_package_scope_methods.length
    VariousMethods.java_class.java_package_scope_methods.each{|java_method| assert java_method.package_scope?}
    VariousMethods.java_class.java_package_scope_class_methods.each{|java_method| assert java_method.package_scope?}
    assert_equal %w[staticPackageSynchronized], VariousMethods.java_class.java_package_scope_methods.map(&:name)
    assert_equal %w[staticPackageSynchronized], VariousMethods.java_class.java_package_scope_class_methods.map(&:name)
  end

  def test_package_scope_instance_methods
    assert_equal(%w[packageSynchronized],
      (VariousMethods.java_class.java_package_scope_instance_methods.map(&:name) -
        java.lang.Object.java_class.java_package_scope_instance_methods.map(&:name)))
    VariousMethods.java_class.java_package_scope_instance_methods.each{|java_method| assert java_method.package_scope?}
  end


  def test_private_class_methods
    assert_equal 1, VariousMethods.java_class.java_private_methods.length
    VariousMethods.java_class.java_private_methods.each{|java_method| assert java_method.private?}
    VariousMethods.java_class.java_private_class_methods.each{|java_method| assert java_method.private?}
    assert_equal %w[staticPrivate], VariousMethods.java_class.java_private_methods.map(&:name)
    assert_equal %w[staticPrivate], VariousMethods.java_class.java_private_class_methods.map(&:name)
  end

  def test_private_instance_methods
    assert_equal(%w[privateFinal],
      (VariousMethods.java_class.java_private_instance_methods.map(&:name) -
        java.lang.Object.java_class.java_private_instance_methods.map(&:name)))
    VariousMethods.java_class.java_private_instance_methods.each{|java_method| assert java_method.private?}
  end


  def test_final_class_methods
    assert_equal 1, VariousMethods.java_class.java_final_methods.length
    VariousMethods.java_class.java_final_methods.each{|java_method| assert java_method.final?}
    VariousMethods.java_class.java_final_class_methods.each{|java_method| assert java_method.final?}
    assert_equal %w[staticProtectedFinal], VariousMethods.java_class.java_final_methods.map(&:name)
    assert_equal %w[staticProtectedFinal], VariousMethods.java_class.java_final_class_methods.map(&:name)
  end

  def test_final_instance_methods
    assert_equal(%w[protectedFinal privateFinal],
      (VariousMethods.java_class.java_final_instance_methods.map(&:name) -
        java.lang.Object.java_class.java_final_instance_methods.map(&:name)))
    VariousMethods.java_class.java_final_instance_methods.each{|java_method| assert java_method.final?}
  end
  
end
