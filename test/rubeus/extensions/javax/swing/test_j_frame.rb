require 'test/unit'
require 'rubygems'
require 'rubeus'

# Test for j_frame.rb
class TestJFrame < Test::Unit::TestCase
	include Rubeus::Swing

	# setup method
	def setup
	end

	# normal pattern
	def test_normal
		JFrame.new do |f|
			JPanel.new do |p|
				JButton.new("Push!")
			end

			assert_equal(400, f.width)
			assert_equal(300, f.height)
			assert_equal(JFrame.const_get(:EXIT_ON_CLOSE), f.default_close_operation)	
		end
	end

	# normal pattern with set_size
	if ENV_JAVA["java.specification.version"] == "1.6"
		def test_normal_with_set_size
			JFrame.new do |f|
				JPanel.new do |p|
					JButton.new("Push!")
				end

				f.set_size("300 x 400")

				assert_equal(300, f.width)
				assert_equal(400, f.height)
				assert_equal(JFrame.const_get(:EXIT_ON_CLOSE), f.default_close_operation)	
			end
		end
	end
end
