require File.dirname(__FILE__) + "/spec_helper"
require 'text_based_game'

describe TextBasedGame do
  before do
    @original_stdin, @original_stdout = $stdin, $stdout
    @myio_in, @myio_out = StringIO.new, StringIO.new
    $stdout = @myio_out
    select_board_size_output = "Select from the following board size choices (rows X columns):\n Enter '1' for 3X3\n Enter '2' for 4X4\n"
    select_player_options_output = "Select from the following player options:\n Enter '1' for Computer vs Computer\n Enter '2' for Human vs Computer\n Enter '3' for Human vs Human\n"
    choose_team_output = "What team do you want to be on? X or O?\n"
    choose_difficulty_output = "Select from the following difficulty options:\n Enter '1' for Easy\n Enter '2' for Medium\n Enter '3' for Hard\n"
    choose_rules_output = "Select from the following game rules:\n Enter '1' for standard rules (win by controlling 3 spaces in a row)\n Enter '2' for 2X2 rules (win by controlling a 2X2 block of spaces or 3 in a row)\n"
    @initializers_output_human_vs_comp = select_board_size_output + select_player_options_output + choose_team_output + choose_difficulty_output + choose_rules_output
    @initializers_output_human_vs_human = select_board_size_output + select_player_options_output + choose_rules_output
  end
  
  def start_game
    $stdin = @myio_in
    @p1 = TextHumanPlayer.new(X)
    @p2 = TextHumanPlayer.new(O)
    @my_game = TextBasedGame.new
  end
  
  after do
    $stdin.close ; $stdout.close
    $stdin, $stdout = @original_stdin, @original_stdout
  end
  
  it "GameEngine.initialize calls methods that set the board size and player information." do
    @myio_in.string = "1\n2\nx\n3\n2"
    start_game
    @myio_out.string.should == @initializers_output_human_vs_comp
  end
  
  it "run_computers_turn(team) makes a move based off of what the Calculate class says would be the best move." do
    @myio_in.string = "1\n2\nO\n3\n1"
    start_game
    @my_game.run_turn(X)
    @myio_out.string.should == @initializers_output_human_vs_comp
  end
  
  it "run_humans_turn(team) makes a move based off of human input." do
    @myio_in.string = "1\n2\nX\n3\n1\n5"
    start_game
    @my_game.run_turn(X)
    @myio_out.string.should == @initializers_output_human_vs_comp
  end
  
  it "validate_move(move) ensures that a valid move is being made" do
    @myio_in.string = "1\n2\nX\n3\n1\n99\n4"
    start_game
    @my_game.run_turn(X)
    @myio_out.string.should == @initializers_output_human_vs_comp
  end
  
  it "game_over ends the game and prints whether x won, o won, or nobody won" do
    setup_draw
    @my_game.game_over
    @myio_out.string.should == @initializers_output_human_vs_human + @move_output_9
  end
  
  def setup_draw
    @myio_in.string = "1\n3\n1\n1\n2\n2\n99\n3\n5\n4\n6\n8\n7\n9\n"
    start_game
    @my_game.run_turn(@p1)
    @my_game.run_turn(@p2)
    @my_game.run_turn(@p1)
    @my_game.run_turn(@p2)
    @my_game.run_turn(@p1)
    @my_game.run_turn(@p2)
    @my_game.run_turn(@p1)
    @my_game.run_turn(@p2)
    @my_game.run_turn(@p1)
    @move_output_9 = "Select location of next move:\nMove successfully made\nSelect location of next move:\nMove successfully made\nSelect location of next move:\nCannot move to a space that is already full\nSelect location of next move:\n|X|O|3|\n|4|5|6|\n|7|8|9|\nInvalid Move. Please select another move:\nMove successfully made\nSelect location of next move:\nMove successfully made\nSelect location of next move:\nMove successfully made\nSelect location of next move:\nMove successfully made\nSelect location of next move:\nMove successfully made\nSelect location of next move:\nMove successfully made\n|X|O|O|\n|O|X|X|\n|X|O|9|\n"
  end
end