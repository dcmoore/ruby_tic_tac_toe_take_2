require File.dirname(__FILE__) + "/spec_helper"
require 'game_engine'
require 'stringio'

describe GameEngine do
  before do
    @original_stdin, @original_stdout = $stdin, $stdout
    @myio_in, @myio_out = StringIO.new, StringIO.new
    $stdout = @myio_out
    @initializers_output = "size of @board will be 3 rows by 3 columns\nNumber of players. 1 or 2?\nWhat team do you want to be on? X or O?\n"
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
    @myio_in.string = "1\nx"
    start_game
    @myio_out.string.should == @initializers_output
  end
  
  it "run_computers_turn(team) makes a move based off of what the Calculate class says would be the best move." do
    @myio_in.string = "1\nO"
    start_game
    @my_game.run_computers_turn(X)
    @myio_out.string.should == @initializers_output + "Please wait, computer thinking of next move...\n1 1\nComputer moved to space: 11\n"
  end
  
  it "run_humans_turn(team) makes a move based off of human input." do
    @myio_in.string = "1\nX\n12"
    start_game
    @my_game.run_humans_turn(X)
    @myio_out.string.should == @initializers_output + "type location of next move Ex. '01' for row 0 and column 1\nMove successfully made\n"
  end
  
  it "validate_move(move) ensures that a valid move is being made" do
    @myio_in.string = "1\nX\n00"
    start_game
    @my_game.validate_move("99")
    @myio_out.string.should == @initializers_output + "Invalid Move\ntype location of next move Ex. '01' for row 0 and column 1\n"
  end
  
  it "game_over ends the game and prints whether x won, o won, or nobody won" do
    setup_draw
    @my_game.game_over
    @myio_out.string.should == @initializers_output + @move_output_9 + "Draw\n"
  end
  
  def setup_draw
    @myio_in.string = "1\nX\n00\n01\n02\n11\n10\n12\n21\n20\n22\n"
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
    @move_output_9 = "type location of next move Ex. '01' for row 0 and column 1\nMove successfully made\ntype location of next move Ex. '01' for row 0 and column 1\nMove successfully made\ntype location of next move Ex. '01' for row 0 and column 1\nMove successfully made\ntype location of next move Ex. '01' for row 0 and column 1\nMove successfully made\ntype location of next move Ex. '01' for row 0 and column 1\nMove successfully made\ntype location of next move Ex. '01' for row 0 and column 1\nMove successfully made\ntype location of next move Ex. '01' for row 0 and column 1\nMove successfully made\ntype location of next move Ex. '01' for row 0 and column 1\nMove successfully made\ntype location of next move Ex. '01' for row 0 and column 1\nMove successfully made\n"
  end
end
