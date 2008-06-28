JavaUtilities.extend_proxy('javax.swing.JSplitPane') do
  perform_as_container

  def self.add_new_component_to(object, &block)
    Rubeus::Swing::Nestable::Context.add_new_component_to(object, :append_component, &block)
  end
  
  def append_component(component)
    append_method =
      (self.orientation == javax.swing.JSplitPane::VERTICAL_SPLIT) ?
        (top_component ? :set_bottom_component : :set_top_component) :
        (left_component ? :set_right_component : :set_left_component)
    send(append_method, component)
  end
end

Rubeus::Swing.attach_component('JSplitPane')
