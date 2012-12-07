module Bacon
  class Context
    # Sets up a new @row RowType object to be reset before every test.
    #
    # @param row_settings is a hash of row settings or a symbol
    #   corresponding to a row type
    # @param block is optional; the @row object is passed if given.
    #
    # EX
    # test_row :image
    # => tests the RowType::ImageRow
    # test_row title: "Title", key: "some key", type: :string
    # => tests the RowType::StringRow
    def tests_row(row_settings, &block)
      if row_settings.is_a? Symbol
        type = row_settings
        row_settings = { type: type, key: type, title: type.capitalize.to_s }
      end
      before do
        row_id = row_settings.delete(:row_id) || 'test'
        grouped = row_settings.delete(:grouped)
        position_type = row_settings.delete(:position_type)
        @row = Formotion::Row.new(row_settings)
        @row.reuse_identifier = row_id
        make_row_grouped(@row, grouped) if !grouped.nil?
        make_row_at_position(@row, position) if !position_type.nil?
        block && block.call(@row)
      end
    end

    def make_row_grouped(row, grouped = true)
      row.tap do |r|
        def r.form
          @form ||= Object.new.tap do |o|
            def o.table
              @table ||= Object.new.tap do |t|
                def t.grouped?
                  @grouped
                end
              end
            end
          end
        end
      end

      row.form.table.instance_variable_set("@grouped", grouped)

      row
    end

    def make_row_at_position(row, position)
      row.tap do |r|
        def r.position_type
          @position_type
        end
      end

      row.instance_variable_set("@position_type", position)

      row
    end

    def assert_gradient_components(gradient, components)
      if components.is_a?(UIColor)
        components = [components, components]
      end

      _components = []
      components.each do |ui_color|
        ptr = CGColorGetComponents(ui_color.CGColor)
        4.times do |i|
          _components << ptr[i]
        end
      end

      gradient.instance_variable_get("@components").should == _components
    end
  end
end