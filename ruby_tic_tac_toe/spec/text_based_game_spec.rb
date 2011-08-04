require File.dirname(__FILE__) + "/spec_helper"
require 'text_based_game'
require 'board'

describe TextBasedGame do
  before do
    @original_stdin, @original_stdout = $stdin, $stdout
    @myio_in, @myio_out = StringIO.new, StringIO.new
    $stdout = @myio_out
    select_player_options_output = "Select from the following player options:\n Enter '1' for Computer vs Computer\n Enter '2' for Human vs Computer\n Enter '3' for Human vs Human\n Enter '4' to play a LAN game\n"
    choose_team_output = "What team do you want to be on? X or O?\n"
    choose_difficulty_output = "Select from the following difficulty options:\n Enter '1' for Easy\n Enter '2' for Medium\n Enter '3' for Hard\n"
    select_board_size_output = "Select from the following board size choices (rows X columns):\n Enter '1' for 3X3\n Enter '2' for 4X4\n Enter '3' to load a previously saved board\n"
    choose_rules_output = "Select from the following game rules:\n Enter '1' for standard rules (win by controlling 3 spaces in a row)\n Enter '2' for 2X2 rules (win by controlling a 2X2 block of spaces or 3 in a row)\n"
    @initializers_output_human_vs_comp = select_player_options_output + choose_team_output + choose_difficulty_output + select_board_size_output + choose_rules_output
    @initializers_output_human_vs_human = select_player_options_output + select_board_size_output + choose_rules_output
    @initializers_output_load_board = select_player_options_output + select_board_size_output + "Enter the file name to your previously saved game:\nNo file found\nEnter the file name to your previously saved game:\n" + choose_rules_output
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
    @myio_in.string = "2\nx\n3\n1\n1\n"
    start_game
    @myio_out.string.should == @initializers_output_human_vs_comp
  end
  
  it "run_computers_turn(team) makes a move based off of what the Calculate class says would be the best move." do
    @myio_in.string = "2\nO\n3\n1\n1\n"
    start_game
    @my_game.run_turn(X)
    @myio_out.string.should == @initializers_output_human_vs_comp
  end
  
  it "run_humans_turn(team) makes a move based off of human input." do
    @myio_in.string = "2\nX\n3\n1\n1\n5\n"
    start_game
    @my_game.run_turn(X)
    @myio_out.string.should == @initializers_output_human_vs_comp
  end
  
  it "validate_move(move) ensures that a valid move is being made" do
    @myio_in.string = "2\nX\n3\n1\n1\n99\n4\n"
    start_game
    @my_game.run_turn(X)
    @myio_out.string.should == @initializers_output_human_vs_comp
  end
  
  it "get_saved_board - private method that loads up a previously saved board from file" do
    @myio_in.string = "3\n3\ninvalid@\ntest\n1\n"
    File.open("temp/test_save_game.txt","wb") {|file| Marshal.dump(Board.new(4,4),file)}
    start_game
    @myio_out.string.should == @initializers_output_load_board
  end
  
  it "save_and_exit - private method of TextHumanPlayer invoked by TextBasedGame" do
    if File.exist?("temp/test_save_game.txt") == true
      File.delete("temp/test_save_game.txt")
    end
    
    @myio_in.string = "2\nX\n3\n1\n1\n5\nS\ninvalid%\ntest"
    start_game
    @my_game.run_game
    @myio_out.string.should == @initializers_output_human_vs_comp + "|1|2|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|1|2|3|\n|4|X|6|\n|7|8|9|\nPlease wait, computer thinking of next move...\nComputer moved to space: 1\n|O|2|3|\n|4|X|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nEnter the name you wish to save your game under:\nInvalid file name\nEnter the name you wish to save your game under:\n"
  end
  
  it "game_over ends the game and prints whether x won, o won, or nobody won" do
    setup_draw
    @my_game.game_over
    @myio_out.string.should == @initializers_output_human_vs_human + @move_output_9
  end
  
  def setup_draw
    @myio_in.string = "3\n1\n1\n1\n2\n2\n99\n3\n5\n4\n6\n8\n7\n9\nn\n"
    start_game
    @my_game.run_game
    @move_output_9 = "|1|2|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|2|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nCannot move to a space that is already full\n|X|O|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\n|X|O|3|\n|4|5|6|\n|7|8|9|\nInvalid Move. Please select another move:\nMove successfully made\n|X|O|X|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|4|O|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|X|O|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|X|O|O|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|X|O|O|\n|7|X|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|X|O|O|\n|O|X|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|X|O|O|\n|O|X|X|\nDraw\nWant to play again?\n Enter 'y' to play again\n Enter 'n' to exit\nThanks for playing!\n"
  end
  
  it "game_over also checks to see if user wants to play again" do
    setup_two_draws
    @my_game.game_over
    @myio_out.string.should == @initializers_output_human_vs_human + @move_output_9_plus
  end
  
  def setup_two_draws
    @myio_in.string = "3\n1\n1\n1\n2\n2\n99\n3\n5\n4\n6\n8\n7\n9\ny\nn\n3\n1\n1\n1\n2\n2\n99\n3\n5\n4\n6\n8\n7\n9\nn\n"
    start_game
    @my_game.run_game
    @move_output_9_plus = "|1|2|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|2|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nCannot move to a space that is already full\n|X|O|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\n|X|O|3|\n|4|5|6|\n|7|8|9|\nInvalid Move. Please select another move:\nMove successfully made\n|X|O|X|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|4|O|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|X|O|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|X|O|O|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|X|O|O|\n|7|X|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|X|O|O|\n|O|X|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|X|O|O|\n|O|X|X|\nDraw\nWant to play again?\n Enter 'y' to play again\n Enter 'n' to exit\nWant to use the same game settings?\n Enter 'y' to use the same settings\n Enter 'n' to choose new settings\n" + @initializers_output_human_vs_human + "|1|2|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|2|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nCannot move to a space that is already full\n|X|O|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\n|X|O|3|\n|4|5|6|\n|7|8|9|\nInvalid Move. Please select another move:\nMove successfully made\n|X|O|X|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|4|O|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|X|O|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|X|O|O|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|X|O|O|\n|7|X|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|X|O|O|\n|O|X|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|X|O|O|\n|O|X|X|\nDraw\nWant to play again?\n Enter 'y' to play again\n Enter 'n' to exit\nThanks for playing!\n"
  end
end