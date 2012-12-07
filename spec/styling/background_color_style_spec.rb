describe "BackgroundColorStyle" do

  describe "with hex" do
    tests_row type: :string, style: {background_color: "333333"}, grouped: true

    it "should work" do
      cell = @row.make_cell
      @row.will_display(cell)
      cell.backgroundColor.should == "333333".to_color
    end
  end

  describe "with gradient" do
    tests_row type: :string, style: {background_color: {top: "red", bottom: "blue"}}, grouped: true

    it "should work" do
      @row.tap do |r|
        def r.position_type
          :single
        end
      end

      cell = @row.make_cell
      @row.will_display(cell)
      cell.backgroundView.is_a?(GradientBackgroundView).should == true

      assert_gradient_components(cell.backgroundView, [UIColor.redColor, UIColor.blueColor])
    end
  end
end