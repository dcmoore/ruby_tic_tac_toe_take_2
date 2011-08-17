require 'spec_helper'

describe Move do
  before(:each) do
    @attr = { :game_id => 1, :location => 0, :team => 1 }
  end
  
  it "should create a new instance given valid attributes" do
    Move.create!(@attr)
  end
  
  it "should require a valid game_id" do
    validate_presence_and_numericality(:game_id)
  end
  
  it "should require a valid location" do
    validate_presence_and_numericality(:location)
  end
  
  it "should require a valid location" do
    validate_presence_and_numericality(:team)
  end
  
  def validate_presence_and_numericality(column)
    temp = Move.new(@attr.merge(column => nil))
    temp.should_not be_valid
    temp = Move.new(@attr.merge(column => "some text"))
    temp.should_not be_valid
  end
end