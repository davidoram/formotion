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
        #display_key_label.placeholder = row.placeholder
        
        # Update self when value changes
        observe(self.row, "value") do |old_value, new_value|
          break_with_semaphore do
            if row.value
              self.display_key_label.text = row.value
            end
          end
        end
        
      end

      def update_cell(cell)
        if @value
          self.display_key_label.text = @value
        end
      end

      def on_select(tableView, tableViewDelegate)
        p "on_select controller_callback_method: #{@row.controller_callback_method}"
        p "row #{@row}"
        p "row.form #{@row.form}"
        p "row.form.controller #{@row.form.controller}"
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



=begin
      def update_cell_value(cell)
        cell.accessoryType = row.value ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone
      end


      # This is actually called whenever again cell is checked/unchecked
      # in the UITableViewDelegate callbacks. So (for now) don't
      # instantiate long-lived objects in them.
      # Maybe that logic should be moved elsewhere?
      def build_cell(cell)
        update_cell_value(cell)
        observe(self.row, "value") do |old_value, new_value|
          update_cell_value(cell)
        end
        nil
      end
      # Configures the cell to have a new UITextField
      # which is used to enter data. Consists of
      # 1) setting up that field with the appropriate properties
      # specified by `row` 2) configures the callbacks on the field
      # to call any callbacks `row` listens for.
      # Also does the layoutSubviews swizzle trick
      # to size the UITextField so it won't bump into the titleLabel.
      def build_cell(cell)
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator 
        
        field = UITextField.alloc.initWithFrame(CGRectZero)
        field.tag = TEXT_FIELD_TAG

        field.clearButtonMode = UITextFieldViewModeWhileEditing
        field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
        field.textAlignment = row.text_alignment || UITextAlignmentRight

        field.secureTextEntry = true if row.secure?
        field.returnKeyType = row.return_key || UIReturnKeyNext
        field.autocapitalizationType = row.auto_capitalization if row.auto_capitalization
        field.autocorrectionType = row.auto_correction if row.auto_correction
        field.clearButtonMode = row.clear_button || UITextFieldViewModeWhileEditing
        field.enabled = false

        cell.swizzle(:layoutSubviews) do
          def layoutSubviews
            old_layoutSubviews

            # viewWithTag is terrible, but I think it's ok to use here...
            formotion_field = self.viewWithTag(TEXT_FIELD_TAG)
            formotion_field.sizeToFit

            field_frame = formotion_field.frame
            field_frame.origin.x = self.textLabel.frame.origin.x + self.textLabel.frame.size.width + Formotion::RowType::Base.field_buffer
            field_frame.origin.y = ((self.frame.size.height - field_frame.size.height) / 2.0).round
            field_frame.size.width = self.frame.size.width - field_frame.origin.x - Formotion::RowType::Base.field_buffer - Accessory
            formotion_field.frame = field_frame
          end
        end

        if UIDevice.currentDevice.systemVersion >= "6.0"
          field.swizzle(:setText) do
            def setText(text)
              r = old_setText(text)
              self.sendActionsForControlEvents(UIControlEventEditingChanged)
              r
            end
          end
        end

        field.placeholder = row.placeholder
        field.text = row.value
        cell.addSubview(field)
        field

      end
      

      def on_select(tableView, tableViewDelegate)
        p 'on_select'
        if !row.editable?
          return
        end
        if row.section.select_one and !row.value
          row.section.rows.each do |other_row|
            other_row.value = (other_row == row)
          end
        elsif !row.section.select_one
          row.value = !row.value
        end
      end
=end      
      
  end
end