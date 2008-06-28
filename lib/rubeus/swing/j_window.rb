JavaUtilities.extend_proxy('javax.swing.JWindow') do
  perform_as_container
end

Rubeus::Swing.attach_component('JWindow')
