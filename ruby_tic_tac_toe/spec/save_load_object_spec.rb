require File.dirname(__FILE__) + "/spec_helper"
require 'save_load_object'
require 'tic_tac_toe_board'

describe SaveLoadObject do
  before do
    @obj = TicTacToeBoard.new(4)
    @obj.make_move(0, 5)
  end
  
  it "SaveLoadObject.save - should save a board object" do
    SaveLoadObject.save("test", @obj)
    File.exist?("temp/test_save_game.txt").should == true
  end
  
  it "SaveLoadObject.file_exists?(file_name) - returns true if an object has been saved under the file_name" do
    SaveLoadObject.file_exists?("test").should == true
  end
  
  it "SaveLoadObject.load(file_name) - returns an object that matches the specified file_name" do
    new_obj = SaveLoadObject.load("test")
    new_obj.get_num_moves_made.should == @obj.get_num_moves_made
    new_obj.space_contents(0).should == 5
  end
end