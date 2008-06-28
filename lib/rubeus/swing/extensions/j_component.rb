JavaUtilities.extend_proxy('javax.swing.JComponent') do
  def set_preferred_size_with_rubeus(*args)
    values = args
    if args.length == 1
      if args.first.is_a?(java.awt.Dimension)
        return set_preferred_size_without_rubeus(*args)
      else
        values = args.first.to_s.split("x", 2)
      end
    end
    set_preferred_size_without_rubeus(java.awt.Dimension.new(*values.map{|s|s.to_i}))
  end
  
  alias_method :set_preferred_size_without_rubeus, :set_preferred_size
  alias_method :set_preferred_size, :set_preferred_size_with_rubeus
end
