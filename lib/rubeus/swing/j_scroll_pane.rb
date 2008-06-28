JavaUtilities.extend_proxy('javax.swing.JScrollPane') do
  def self.add_new_component_to(object, &block)
    Rubeus::Swing::Nestable::Context.add_new_component_to(object.viewport, :set_view, object, &block)
  end
end

Rubeus::Swing.attach_component('JScrollPane')
