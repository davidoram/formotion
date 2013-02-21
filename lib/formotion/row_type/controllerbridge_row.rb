#
# Set 'value' to be the value you wish to be displayed
# If value is set, will get a checkmark accessry
# When row is selected, then 'controller_callback_method' will be called
# 
module Formotion
  module RowType
    class ControllerBridgeRow < Base
      
      include BW::KVO
      
      LABEL_TAG=1001
      
      VALUE_COLOR="#385387".to_color

      # 70% gray colour - see UITextfield.placeHolder
      PLACEHOLDER_COLOR=UIColor.colorWithWhite(0.0,alpha:0.25)

      def build_cell(cell)
        cell.accessoryType = cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator

        cell.contentView.addSubview(self.display_key_label)

        cell.swizzle(:layoutSubviews) do
          def layoutSubviews
            old_layoutSubviews

            formotion_label = self.viewWithTag(LABEL_TAG)
            formotion_label.sizeToFit

            field_frame = formotion_label.frame
            # HARDCODED CONSTANT
            field_frame.origin.x = self.contentView.frame.size.width - field_frame.size.width - 10
            field_frame.origin.y = ((self.contentView.frame.size.height - field_frame.size.height) / 2.0).round
            formotion_label.frame = field_frame
          end
        end

        display_key_label.highlightedTextColor = cell.textLabel.highlightedTextColor
        
        # Update self when value changes
        observe(self.row, "value") do |old_value, new_value|
          break_with_semaphore do
            update_cell_value(cell)
          end
        end
      end

      def after_build(cell)
        update_cell_value(cell)
      end

      def update_cell_value(cell)
        if row.value
          self.display_key_label.text = row.value
          self.display_key_label.textColor = VALUE_COLOR
        elsif row.placeholder
          self.display_key_label.text = row.placeholder
          self.display_key_label.textColor = PLACEHOLDER_COLOR
        end
      end

      def on_select(tableView, tableViewDelegate)
        @row.form.controller.send(@row.controller_callback_method) if @row.controller_callback_method 
      end

      def display_key_label
        @display_key_label ||= begin
          label = UILabel.alloc.initWithFrame(CGRectZero)
          label.textColor = "#385387".to_color
          label.tag = LABEL_TAG
          label.backgroundColor = UIColor.clearColor
          label
        end
      end
    end
   
  end
end