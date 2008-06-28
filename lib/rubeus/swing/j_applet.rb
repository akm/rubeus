JavaUtilities.extend_proxy('javax.swing.JApplet') do
  perform_as_container
end

Rubeus::Swing.attach_component('JApplet')
