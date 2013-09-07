$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rubeus'

require 'minitest/autorun'

def assert_nothing_raised
  yield if block_given?
end
