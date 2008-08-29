Rubeus::Swing.depend_on("JComponent")

module Rubeus::Extensions::Javax::Swing
  module JTabbedPane
    def self.included(base)
      base.perform_as_container
      base.extend(ClassMethods)
      base.instance_eval do
        alias :new_without_rubeus :new
        alias :new :new_with_rubeus
      end
    end

    module ClassMethods
      def new_with_rubeus(*args, &block)
        # Convert to constant value if symbol is designated
        new_args = args.map do |arg|
          if arg.is_a?(Symbol)
            const_get(arg)
          else
            arg
          end
        end

        new_without_rubeus(*new_args, &block)
      end
    end

    # set_title_at utility
    def set_titles(arr)
      tab_setting(arr, :set_title_at)
    end

    # set_icon_at utility
    def set_icons(arr)
      tab_setting(arr, :set_image_icon_at)
    end

    # alias for set_icon_at set image_path_string instread
    def set_image_icon_at(index, image_path)
      if image_path && java.io.File.new(image_path).exists
        image_icon = javax.swing.ImageIcon.new(image_path)
        set_icon_at(index, image_icon)
      end
    end

    # set_tool_tip_text_at utility
    def set_tips(arr)
      tab_setting(arr, :set_tool_tip_text_at)
    end

    private
    def tab_setting(arr, method_name)
      self.tab_count.times do |i|
        if arr.length > i
          self.send(method_name, i, arr[i])
        end
      end
    end
  end
end

