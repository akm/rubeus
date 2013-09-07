$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rubeus'

require 'minitest/autorun'

def assert_nothing_raised
  yield if block_given?
end

def assert_raise(klass)
  begin
    yield if block_given?
  rescue Exception => e
    assert_instance_of klass, e
  end
end

def assert_not_nil(obj, msg = nil)
  assert obj, msg
end
