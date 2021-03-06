require 'spec_helper'

describe Book do
  before do
    @valid_attributes = { :title => "Oliver Twist",
                          :description => "A book about an orphan",
                          :year => 1838 }
  end
  
  it "should be valid with valid attributes" do
    book = Book.new(@valid_attributes)
    book.should be_valid   
  end
  
  it "should have a title" do
    @invalid_attributes = @valid_attributes.clone
    @invalid_attributes.delete(:title)
    Book.new(@invalid_attributes).should_not be_valid
  end
  
  it "should have description as empty string by default" do
    @valid_attributes.delete(:description)
    book = Book.create!(@valid_attributes)
    book.description.should == ""
  end
  
  it "should have a year as a number" do
    book = Book.new(@valid_attributes)
    book.year = "foo"
    book.should_not be_valid 
  end


end
