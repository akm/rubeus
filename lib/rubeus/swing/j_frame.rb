JavaUtilities.extend_proxy('javax.swing.JFrame') do
  perform_as_container
end

Rubeus::Swing.attach_component('JFrame')
