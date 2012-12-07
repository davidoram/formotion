module Formotion
  class TableCell < UITableViewCell
    def setHighlighted(highlighted, animated:animated)
      super

      change_colors(highlighted)
    end

    def change_colors(highlighted)
      @old_colors ||= {}
      self.subviews_recursive_each do |subview|
        if !subview.respond_to?("setHighlightedTextColor:") && subview.respond_to?("setTextColor:")
          if !subview.instance_variable_get("@old_text_color")
            subview.instance_variable_set("@old_text_color", subview.textColor)
          end
          old_color = subview.instance_variable_get("@old_text_color")
          subview.textColor = highlighted ? UIColor.whiteColor : old_color
        end
      end
    end
  end
end