JavaUtilities.extend_proxy('javax.swing.JScrollPane') do
  perform_as_container

  def self.add_new_component_to(object, &block)
    Rubeus::Awt::Nestable::Context.add_new_component_to(object.viewport, :set_view, object, &block)
  end
end
