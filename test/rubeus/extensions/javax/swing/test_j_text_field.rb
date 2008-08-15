require 'test/unit'
require 'rubygems'
require 'rubeus'

# Test for j_scroll_pane.rb
class TestJTextField < Test::Unit::TestCase
	include Rubeus::Swing

	# setup method
	def setup
	end

	# normal pattern
	def test_normal
		@key_event_processed = false

		JFrame.new do |f|
			# Register default event keyPress
			jtf = JTextField.new do |key_event|
				assert_equal(java.awt.event.KeyEvent::KEY_PRESSED, key_event.get_id)
				assert_equal(java.awt.event.KeyEvent::VK_A, key_event.get_key_code)
				assert_equal(97, key_event.get_key_char)
				assert_equal(0, key_event.get_modifiers)

				@key_event_processed = true
			end

			f.visible = true

			# Send key pressed event to JTextField
			jtf.dispatch_event(
				java.awt.event.KeyEvent.new(
					jtf, 
					java.awt.event.KeyEvent::KEY_PRESSED, 
					java.lang.System.current_time_millis, 
					0,
					java.awt.event.KeyEvent::VK_A,
					97
				)
			)

			f.dispose
			f.visible = false

			assert_equal(true, @key_event_processed)
		end
	end
end
