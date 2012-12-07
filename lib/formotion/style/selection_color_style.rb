# Determines the look of each row when it's highlighted via a tap

module Formotion
  module RowStyle
    class SelectionColorStyle < Base
      PROPERTIES = [:color, :top, :bottom, :font_color].each { |prop|
        attr_accessor prop
      }

      def self.default_object_key
        :color
      end

      def setup_cell(cell)
        if ["none", "blue", "gray"].member? self.color
          cell.selectionStyle = const_int_get("UITableViewCellSelectionStyle", self.color)
        elsif self.color || (self.top && self.bottom)
          GradientBackgroundView.attach_to_cell(cell, as: "selectedBackgroundView")

          top_color = nil
          bottom_color = nil
          if self.color
            # use color + darker color
            top_color = bottom_color = self.color.to_color
          else
            top_color = self.top.to_color
            bottom_color = self.bottom.to_color
          end

          cell.selectedBackgroundView.colors = [top_color, bottom_color]
        end

        if self.font_color
          change_colors = []
          cell.subviews_recursive_each do |subview|
            if subview.respond_to?("setHighlightedTextColor:")
              subview.setHighlightedTextColor(highlight_text_color(subview))
            elsif subview.respond_to?("setTextColor:")
              change_colors << subview
            end
          end

          if change_colors.count > 0
            cell.instance_variable_set("@change_colors", change_colors)
            cell.instance_variable_set("@change_color", self.font_color)
            cell.instance_eval do
              def change_colors(highlighted)
                @old_colors ||= {}
                @change_colors.each do |subview|
                  if !subview.instance_variable_get("@old_text_color")
                    subview.instance_variable_set("@old_text_color", subview.textColor)
                  end
                  old_color = subview.instance_variable_get("@old_text_color")
                  subview.textColor = (highlighted && @change_color != "none") ? @change_color.to_color : old_color
                end
              end
            end
          end
        end
      end

      def highlight_text_color(view)
        (self.font_color == "none" && view) ? view.textColor : self.font_color.to_color
      end

      def will_display(cell)
        if self.tableView.grouped?
          cell.setPosition(self.row.position_type)
        end
      end

    end
  end
end