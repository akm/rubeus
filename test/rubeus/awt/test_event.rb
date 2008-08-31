require 'test/unit'
require 'rubygems'
require 'rubeus'

# Test for event.rb
class TestEvent < Test::Unit::TestCase
  include Rubeus::Swing

  class TestClass
    include Rubeus::Awt::Event
  end

  # setup method
  def setup
  end

  # test uncapitalize
  def test_uncapitalize
    assert_equal("aBC", TestClass.uncapitalize("ABC"))

    assert_raise(TypeError) do
      TestClass.uncapitalize("")
    end
  end

  # test find_java_method
  def test_find_java_method
    JFrame.new do |f|
      assert_equal("getContentPane", f.find_java_method("getContentPane").name)
    end
  end

  # test find_java_method with parent class's method
  def test_find_java_method_with_parent_class_method
    JFrame.new do |f|
      assert_equal("getTitle", f.find_java_method("getTitle").name)
    end
  end

  # test find_java_method with method not exists
  def test_find_java_method_with_method_not_exists
    JFrame.new do |f|
      assert_nil(f.find_java_method("addActionListener"))
    end
  end

  # test events
  def test_events
    expectedHash = {
      "component"=>["component_hidden", "component_moved", "component_resized", "component_shown"], 
      "container"=>["component_added", "component_removed"], 
      "focus"=>["focus_gained", "focus_lost"], 
      "hierarchy"=>["hierarchy_changed"], 
      "hierarchy_bounds"=>["ancestor_moved", "ancestor_resized"], 
      "input_method"=>["caret_position_changed", "input_method_text_changed"], 
      "key"=>["key_pressed", "key_released", "key_typed"], 
      "mouse"=>["mouse_clicked", "mouse_entered", "mouse_exited", "mouse_pressed", "mouse_released"], 
      "mouse_motion"=>["mouse_dragged", "mouse_moved"], 
      "mouse_wheel"=>["mouse_wheel_moved"], 
      "property_change"=>["property_change"], 
      "window"=>["window_activated", "window_closed", "window_closing", "window_deactivated", "window_deiconified", "window_iconified", "window_opened"], 
      "window_focus"=>["window_gained_focus", "window_lost_focus"], 
      "window_state"=>["window_state_changed"]
    }
    JFrame.new do |f|
      expectedHash.keys.each do |key|
        assert_equal(expectedHash[key].sort, f.events[key].sort)
      end
    end
  end

  # test event_types
  def test_event_types
    expectedArray = ["component", "container", "focus", "hierarchy", "hierarchy_bounds", "input_method", "key", "mouse", "mouse_motion", "mouse_wheel", "property_change", "window", "window_focus", "window_state"]
    JFrame.new do |f|
      assert_equal(expectedArray, f.event_types)
    end
  end

  # test listen
  def test_listen
    @mouse_event_processed = false

    jf = JFrame.new do |f|
      f.listen(:mouse, :mouse_clicked) do |mouse_event|
        assert_equal(java.awt.event.MouseEvent::MOUSE_CLICKED, mouse_event.get_id)
        assert_equal(100, mouse_event.x)
        assert_equal(250, mouse_event.y)
        assert_equal(1, mouse_event.click_count)
        assert_equal(false, mouse_event.popup_trigger?)
        assert_equal(0, mouse_event.get_modifiers)

        @mouse_event_processed = true
      end
    end

    jf.visible = true

    # Send mouse clicked event to JFrame
    jf.dispatch_event(
      java.awt.event.MouseEvent.new(
        jf,
        java.awt.event.MouseEvent::MOUSE_CLICKED, 
        java.lang.System.current_time_millis, 
        0,
        100,
        250,
        1,
        false
      )
    )

    jf.dispose
    jf.visible = false

    assert_equal(true, @mouse_event_processed)
  end

  # test listen with filters
  def test_listen_with_filters
    @mouse_event_processed_count = 0

    jf = JFrame.new do |f|
      f.listen(:mouse, :mouse_clicked, :click_count => 2) do |mouse_event|
        assert_equal(java.awt.event.MouseEvent::MOUSE_CLICKED, mouse_event.get_id)
        assert_equal(100, mouse_event.x)
        assert_equal(250, mouse_event.y)
        assert_equal(2, mouse_event.click_count)
        assert_equal(false, mouse_event.popup_trigger?)
        assert_equal(0, mouse_event.get_modifiers)

        @mouse_event_processed_count = @mouse_event_processed_count + 1
      end
    end

    jf.visible = true

    # Send mouse clicked event to JFrame
    3.times do |i|
      jf.dispatch_event(
        java.awt.event.MouseEvent.new(
          jf,
          java.awt.event.MouseEvent::MOUSE_CLICKED, 
          java.lang.System.current_time_millis, 
          0,
          100,
          250,
          (i+1),  # click_count (1..3)
          false
        )
      )
    end

    jf.dispose
    jf.visible = false

    assert_equal(1, @mouse_event_processed_count)
  end

  # test listen with two filters
  def test_listen_with_two_filters
    @mouse_event_processed_count = 0

    jf = JFrame.new do |f|
      # left button double clicked
      f.listen(:mouse, :mouse_clicked, :click_count => 2, :button => java.awt.event.MouseEvent::BUTTON1) do |mouse_event|
        assert_equal(java.awt.event.MouseEvent::MOUSE_CLICKED, mouse_event.get_id)
        assert_equal(100, mouse_event.x)
        assert_equal(250, mouse_event.y)
        assert_equal(2, mouse_event.click_count)
        assert_equal(false, mouse_event.popup_trigger?)
        assert_equal(java.awt.event.InputEvent::BUTTON1_MASK, mouse_event.get_modifiers)
        assert_equal(java.awt.event.MouseEvent::BUTTON1, mouse_event.get_button)

        @mouse_event_processed_count = @mouse_event_processed_count + 1
      end
    end

    jf.visible = true

    # Send mouse clicked event to JFrame
    jf.dispatch_event(
      java.awt.event.MouseEvent.new(
        jf,
        java.awt.event.MouseEvent::MOUSE_CLICKED, 
        java.lang.System.current_time_millis, 
        java.awt.event.InputEvent::BUTTON1_MASK,
        100,
        250,
        2,
        false,
        java.awt.event.MouseEvent::BUTTON1
      )
    )

    jf.dispatch_event(
      java.awt.event.MouseEvent.new(
        jf,
        java.awt.event.MouseEvent::MOUSE_CLICKED, 
        java.lang.System.current_time_millis, 
        java.awt.event.InputEvent::BUTTON2_MASK,
        100,
        250,
        2,
        false,
        java.awt.event.MouseEvent::BUTTON2
      )
    )

    jf.dispose
    jf.visible = false

    assert_equal(1, @mouse_event_processed_count)
  end
end

