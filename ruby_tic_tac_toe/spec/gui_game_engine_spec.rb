require File.dirname(__FILE__) + "/spec_helper"
require 'gui_game_engine'
gem 'limelight'
require 'limelight/specs/spec_helper'
$PRODUCTION_PATH = File.expand_path(File.dirname(__FILE__) + "/../ui")


describe GUIGameEngine do
  uses_limelight :scene => "board", :hidden => true
    
  def get_prop_by_id(selected_prop)
    prop = scene.find(selected_prop)
    prop.should_not == nil
    return prop
  end
  
  def get_prop_by_name(selected_prop)
    prop = scene.find_by_name(selected_prop)
    prop.should_not == nil
    return prop
  end
    
  it "the squares container should be loaded" do
    get_prop_by_id("squares_container")
  end
  
  it "the options container should be loaded" do
    get_prop_by_id("options_container")
  end
  
  it "all option combo boxes should be loaded" do
    get_prop_by_id("opt_board").value
    get_prop_by_id("opt_rules").value
    get_prop_by_id("opt_player").value
    get_prop_by_id("opt_difficulty").value
    get_prop_by_id("opt_team").value
  end
  
  it "the new game button should be loaded" do
    get_prop_by_id("new_game")
  end
  
  it "should set the board size according to options" do    
    change_option_and_set_new_game("opt_board", "4X4")
    scene.production.game.board.get_num_spaces.should == 16
    get_prop_by_name("square").length.should == 16
  end
  
  it "should set the rules according to options" do    
    change_option_and_set_new_game("opt_rules", "2X2 Block Win")
    scene.production.game.rules.should == "rows_cols_diags_blocks"
  end
  
  it "should set player types according to options" do
    change_option_and_set_new_game("opt_player", "Player vs Player")
    scene.production.game.player_val.should == "Player vs Player"
  end
  
  it "should set ai difficulty according to options" do
    change_option_and_set_new_game("opt_difficulty", "Hard")
    scene.production.game.difficulty.should == "Hard"
  end
  
  it "should set human team according to options" do
    change_option_and_set_new_game("opt_team", "O")
    scene.production.game.team_val.should == "O"
  end
  
  def change_option_and_set_new_game(prop_id, val)
    get_prop_by_id(prop_id).value = val
    get_prop_by_id("new_game").mouse_clicked(nil)
  end
  
  it "should mark the board with the appropriate team" do
    change_option_and_set_new_game("opt_player", "Player vs AI")
    scene.production.game.current_team(scene.production.game.board).should == X
    get_prop_by_id("0").mouse_clicked(nil)
    get_prop_by_id("0").text.should == "X"
    scene.production.game.board.get_num_moves_made.should == 2  # Computer should move automatically
  end
  
  it "should run through a whole game automatically if AI vs AI is chosen" do
    change_option_and_set_new_game("opt_player", "AI vs AI")
    get_prop_by_id("0").style.background_color.should == "#ff0000ff"  # Red
  end
  
  it "should make the first move if human team is set to O and it is Player vs AI" do
    change_option_and_set_new_game("opt_player", "Player vs AI")
    change_option_and_set_new_game("opt_team", "O")
    scene.production.game.board.get_num_moves_made.should == 1
  end
  
  it "shouldn't let a user make a move on a space that isn't empty" do
    change_option_and_set_new_game("opt_player", "Player vs Player")
    get_prop_by_id("0").mouse_clicked(nil)
    get_prop_by_id("0").mouse_clicked(nil)
    scene.production.game.board.get_num_moves_made.should == 1
  end
  
  it "should close" do
    scene.production.close
  end
end