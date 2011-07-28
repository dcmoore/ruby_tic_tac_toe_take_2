require File.dirname(__FILE__) + "/spec_helper"
require 'game_engine'

describe GameEngine do
  before do
    @original_stdin, @original_stdout = $stdin, $stdout
    @myio_in, @myio_out = StringIO.new, StringIO.new
    $stdout = @myio_out
    select_board_size_output = "Select from the following board size choices (rows X columns):\n Enter '1' for 3X3\n Enter '2' for 4X4\n"
    select_player_options_output = "Select from the following player options:\n Enter '1' for Computer vs Computer\n Enter '2' for Human vs Computer\n Enter '3' for Human vs Human\n"
    choose_team_output = "What team do you want to be on? X or O?\n"
    choose_difficulty_output = "Select from the following difficulty options:\n Enter '1' for Easy\n Enter '2' for Medium\n Enter '3' for Hard\n"
    @initializers_output_human_vs_comp = select_board_size_output + select_player_options_output + choose_team_output + choose_difficulty_output
  end
  
  def start_game
    $stdin = @myio_in
    @my_game = GameEngine.new
  end
  
  after do
    $stdin.close ; $stdout.close
    $stdin, $stdout = @original_stdin, @original_stdout
  end
  
  it "GameEngine.initialize calls methods that set the board size and player information." do
    @myio_in.string = "1\n2\nx\n3"
    start_game
    @myio_out.string.should == @initializers_output_human_vs_comp
  end
  
  it "run_computers_turn(team) makes a move based off of what the Calculate class says would be the best move." do
    @myio_in.string = "1\n2\nO\n3"
    start_game
    @my_game.run_computers_turn(X)
    @myio_out.string.should == @initializers_output_human_vs_comp + "Please wait, computer thinking of next move...\nComputer moved to space: 0\n"
  end
  
  it "run_humans_turn(team) makes a move based off of human input." do
    @myio_in.string = "1\n2\nX\n3\n5"
    start_game
    @my_game.run_humans_turn(X)
    @myio_out.string.should == @initializers_output_human_vs_comp + "type location of next move Ex. '0' for the top-left or '8' for the bottom-right\nMove successfully made\n"
  end
  
  it "validate_move(move) ensures that a valid move is being made" do
    @myio_in.string = "1\n2\nX\n3\n00"
    start_game
    @my_game.validate_move("99")
    @myio_out.string.should == @initializers_output_human_vs_comp + "Invalid Move\ntype location of next move Ex. '0' for the top-left or '8' for the bottom-right\n"
  end
  
  it "game_over ends the game and prints whether x won, o won, or nobody won" do
    setup_draw
    @my_game.game_over
    @myio_out.string.should == @initializers_output_human_vs_comp + @move_output_9 + "Draw\n"
  end
  
  def setup_draw
    @myio_in.string = "1\n2\nX\n3\n0\n1\n2\n4\n3\n5\n7\n6\n8\n"
    start_game
    @my_game.run_humans_turn(X)
    @my_game.run_humans_turn(O)
    @my_game.run_humans_turn(X)
    @my_game.run_humans_turn(O)
    @my_game.run_humans_turn(X)
    @my_game.run_humans_turn(O)
    @my_game.run_humans_turn(X)
    @my_game.run_humans_turn(O)
    @my_game.run_humans_turn(X)
    @move_output_9 = "type location of next move Ex. '0' for the top-left or '8' for the bottom-right\nMove successfully made\ntype location of next move Ex. '0' for the top-left or '8' for the bottom-right\nMove successfully made\ntype location of next move Ex. '0' for the top-left or '8' for the bottom-right\nMove successfully made\ntype location of next move Ex. '0' for the top-left or '8' for the bottom-right\nMove successfully made\ntype location of next move Ex. '0' for the top-left or '8' for the bottom-right\nMove successfully made\ntype location of next move Ex. '0' for the top-left or '8' for the bottom-right\nMove successfully made\ntype location of next move Ex. '0' for the top-left or '8' for the bottom-right\nMove successfully made\ntype location of next move Ex. '0' for the top-left or '8' for the bottom-right\nMove successfully made\ntype location of next move Ex. '0' for the top-left or '8' for the bottom-right\nMove successfully made\n"
  end
end