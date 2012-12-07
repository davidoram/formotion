describe "FontColorStyle" do

  describe "with hex" do
    tests_row type: :string, style: {font_color: "333333"}

    it "should work" do
      cell = @row.make_cell
      cell.textLabel.textColor.should == "333333".to_color
      cell.detailTextLabel.textColor.should == "333333".to_color
      @row.text_field.textColor.should == "333333".to_color
    end
  end

  describe "with word" do
    tests_row type: :string, style: {font_color: "red"}

    it "should work" do
      cell = @row.make_cell
      cell.textLabel.textColor.should == UIColor.redColor
      cell.detailTextLabel.textColor.should == UIColor.redColor
      @row.text_field.textColor.should == UIColor.redColor
    end
  end

  describe "with hash" do
    tests_row type: :string, style: {font_color: {title: "blue", subtitle: "green", value: "black"}}

    it "should work" do
      cell = @row.make_cell
      cell.textLabel.textColor.should == UIColor.blueColor
      cell.detailTextLabel.textColor.should == UIColor.greenColor
      @row.text_field.textColor.should == UIColor.blackColor
    end
  end
end