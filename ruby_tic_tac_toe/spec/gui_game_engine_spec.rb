require File.dirname(__FILE__) + "/spec_helper"
require 'gui_game_engine'
gem 'limelight'


describe GUIGameEngine do
  before do
  end
  
  it "should change text_color on click" do
    uses_limelight :scene => "main", :hidden => true
  end
  
  it "should set x to space that was selected during x's turn" do
  end
  
  it "should set o to space that was selected during o's turn" do
  end
  
  it "should set the board size according to options" do
  end
  
  it "should set player types according to options" do
  end
  
  it "should set player team according to options" do
  end
  
  it "should set difficulty level according to options" do
  end
  
  it "should make a move based off of what the Calculate class says would be the best move." do
  end
  
  it "should end game when Calculate.is_game_over?(board) indicates the game is over" do
  end
end