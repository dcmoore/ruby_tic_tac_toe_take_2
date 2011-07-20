require File.dirname(__FILE__) + "/spec_helper"
require 'space'

describe Space do
  it "Space initializer with 2 arguments" do
    space1 = Space.new(1,1,nil)
    space1.row.should == 1
    space1.col.should == 1
    space1.val.should == nil
  end
end
