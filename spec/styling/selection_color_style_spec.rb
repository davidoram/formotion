describe "SelectionColorStyle" do

  describe "with system default" do
    [["none", UITableViewCellSelectionStyleNone], ["blue", UITableViewCellSelectionStyleBlue], ["gray", UITableViewCellSelectionStyleGray]].each do |key, style|
      tests_row type: :string, style: {selection_color: key}, grouped: true

      it "should work with #{key}" do
        cell = @row.make_cell
        cell.selectionStyle.should == style
      end
    end
  end

  describe "with hex" do
    tests_row type: :string, style: {selection_color: "333333"}, grouped: true
    it "should work" do
      cell = @row.make_cell

      assert_gradient_components(cell.selectedBackgroundView, "333333".to_color)
    end
  end

  describe "with word" do
    tests_row type: :string, style: {selection_color: "red"}, grouped: true
    it "should work" do
      cell = @row.make_cell

      assert_gradient_components(cell.selectedBackgroundView, UIColor.redColor)
    end
  end

  describe "with gradient" do
    tests_row type: :string, style: {selection_color: {top: "red", bottom: "blue"}}, grouped: true

    it "should work" do
      cell = @row.make_cell

      assert_gradient_components(cell.selectedBackgroundView, [UIColor.redColor, UIColor.blueColor])
    end
  end

  describe "with font_color" do
    tests_row type: :string, style: {selection_color: {font_color: "red"}}, grouped: true

    it "should work" do
      cell = @row.make_cell
      cell.change_colors(true)

      cell.subviews_recursive_each do |subview|
        if subview.respond_to?("highlightedTextColor")
          subview.highlightedTextColor.should == UIColor.redColor
        elsif subview.respond_to?("textColor")
          subview.textColor.should == UIColor.redColor
        end
      end
    end
  end
end