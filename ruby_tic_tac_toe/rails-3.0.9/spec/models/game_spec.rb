require 'spec_helper'

describe Game do
  before(:each) do
    @attr = { :outcome => "X Won" }
  end
  
  it "should create a new instance given valid attributes" do
    Game.create!(@attr)
  end
  
  it "should require a valid outcome" do
    temp = Game.new(@attr.merge(:outcome => nil))
    temp.should_not be_valid
    temp = Game.new(@attr.merge(:outcome => "invalid input"))
    temp.should_not be_valid
  end
end