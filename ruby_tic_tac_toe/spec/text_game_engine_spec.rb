require File.dirname(__FILE__) + "/spec_helper"
require 'text_game_engine'
require 'tic_tac_toe_board'

describe TextGameEngine do
  before do
    @original_stdin, @original_stdout = $stdin, $stdout
    @myio_in, @myio_out = StringIO.new, StringIO.new
    $stdout = @myio_out
    select_player_options_output = "Select from the following player options:\n Enter '1' for Computer vs Computer\n Enter '2' for Human vs Computer\n Enter '3' for Human vs Human\n Enter '4' to play a LAN game\n"
    choose_team_output = "What team do you want to be on? X or O?\n"
    choose_difficulty_output = "Select from the following difficulty options for AIBot:\n Enter '1' for Easy\n Enter '2' for Medium\n Enter '3' for Hard\n"
    select_board_size_output = "Select from the following board size choices (rows X columns):\n Enter '1' for 3X3\n Enter '2' for 4X4\n Enter '3' to load a previously saved board\n"
    choose_rules_output = "Select from the following game rules:\n Enter '1' for standard rules (win by controlling 3 spaces in a row)\n Enter '2' for 2X2 rules (win by controlling a 2X2 block of spaces or 3 in a row)\n"
    @initializers_output_human_vs_comp = choose_rules_output + select_player_options_output + choose_team_output + choose_difficulty_output + select_board_size_output
    @initializers_output_human_vs_human = choose_rules_output + select_player_options_output + select_board_size_output
    @initializers_output_load_board = select_player_options_output + select_board_size_output + "Enter the file name to your previously saved game:\nNo file found\nEnter the file name to your previously saved game:\n" + choose_rules_output
    @three_by_three_board_output = "|1|2|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|2|3|\n|4|5|6|\n|7|8|9|\nPlease wait, computer thinking of next move...\nComputer moved to space: 5\n|X|2|3|\n|4|O|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|X|3|\n|4|O|6|\n|7|8|9|\nPlease wait, computer thinking of next move...\nComputer moved to space: 3\n|X|X|O|\n|4|O|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|X|O|\n|X|O|6|\n|7|8|9|\nPlease wait, computer thinking of next move...\nComputer moved to space: 7\n|X|X|O|\n|X|O|6|\n|O|8|9|\nAIBot wins!\nWant to play again?\n Enter 'Y' to play again\n Enter 'N' to exit\nThanks for playing!\n"
    @invalid_input = "|1|2|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|2|3|\n|4|5|6|\n|7|8|9|\nPlease wait, computer thinking of next move...\nComputer moved to space: 5\n|X|2|3|\n|4|O|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|X|3|\n|4|O|6|\n|7|8|9|\nPlease wait, computer thinking of next move...\nComputer moved to space: 3\n|X|X|O|\n|4|O|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nCannot move to a space that is already full\n|X|X|O|\n|4|O|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nInvalid input. Please try again.\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|X|O|\n|X|O|6|\n|7|8|9|\nPlease wait, computer thinking of next move...\nComputer moved to space: 7\n|X|X|O|\n|X|O|6|\n|O|8|9|\nAIBot wins!\nWant to play again?\n Enter 'Y' to play again\n Enter 'N' to exit\nThanks for playing!\n"
  end
  
  def start_game
    $stdin = @myio_in
    @my_game = TextGameEngine.new
  end
  
  after do
    $stdin.close ; $stdout.close
    $stdin, $stdout = @original_stdin, @original_stdout
  end
  
  it "GameEngine.initialize calls methods that set the board size and player information, then run the game." do
    @myio_in.string = "1\n2\nx\n3\n1\n" + "1\n2\n4\nn\n"
    start_game
    @myio_out.string.should == @initializers_output_human_vs_comp + @three_by_three_board_output
  end

  it "validate_move(move) ensures that a valid move is being made" do
    @myio_in.string = "1\n2\nx\n3\n1\n" + "1\n2\n2\n88\n4\nn\n"
    start_game
    @myio_out.string.should == @initializers_output_human_vs_comp + @invalid_input
  end
  
  it "testing to see if the save/load functions work" do
    @myio_in.string = "2\n2\no\n3\n2\n10\nS\nyarbles@\nyarbles\ny\nn\n2\n1\n3\n3\n3\nyarbles\nn\n"
    start_game
    @myio_out.string.should == "Select from the following game rules:\n Enter '1' for standard rules (win by controlling 3 spaces in a row)\n Enter '2' for 2X2 rules (win by controlling a 2X2 block of spaces or 3 in a row)\nSelect from the following player options:\n Enter '1' for Computer vs Computer\n Enter '2' for Human vs Computer\n Enter '3' for Human vs Human\n Enter '4' to play a LAN game\nWhat team do you want to be on? X or O?\nSelect from the following difficulty options for AIBot:\n Enter '1' for Easy\n Enter '2' for Medium\n Enter '3' for Hard\nSelect from the following board size choices (rows X columns):\n Enter '1' for 3X3\n Enter '2' for 4X4\n Enter '3' to load a previously saved board\n| 1| 2| 3| 4|\n| 5| 6| 7| 8|\n| 9|10|11|12|\n|13|14|15|16|\nPlease wait, computer thinking of next move...\nComputer moved to space: 1\n| X| 2| 3| 4|\n| 5| 6| 7| 8|\n| 9|10|11|12|\n|13|14|15|16|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n| X| 2| 3| 4|\n| 5| 6| 7| 8|\n| 9| O|11|12|\n|13|14|15|16|\nPlease wait, computer thinking of next move...\nComputer moved to space: 6\n| X| 2| 3| 4|\n| 5| X| 7| 8|\n| 9| O|11|12|\n|13|14|15|16|\nSelect location of next move (or enter 'S' to save board and exit game):\nEnter a file name to save your board to:\nInvalid input. Please try again.\nEnter a file name to save your board to:\n| X| 2| 3| 4|\n| 5| X| 7| 8|\n| 9| O|11|12|\n|13|14|15|16|\nWant to play again?\n Enter 'Y' to play again\n Enter 'N' to exit\nWant to use the same game settings?\n Enter 'Y' to use the same settings\n Enter 'N' to choose new settings\nSelect from the following game rules:\n Enter '1' for standard rules (win by controlling 3 spaces in a row)\n Enter '2' for 2X2 rules (win by controlling a 2X2 block of spaces or 3 in a row)\nSelect from the following player options:\n Enter '1' for Computer vs Computer\n Enter '2' for Human vs Computer\n Enter '3' for Human vs Human\n Enter '4' to play a LAN game\nSelect from the following difficulty options for AIBot1:\n Enter '1' for Easy\n Enter '2' for Medium\n Enter '3' for Hard\nSelect from the following difficulty options for AIBot2:\n Enter '1' for Easy\n Enter '2' for Medium\n Enter '3' for Hard\nSelect from the following board size choices (rows X columns):\n Enter '1' for 3X3\n Enter '2' for 4X4\n Enter '3' to load a previously saved board\nEnter the file name that your board is saved under:\n| X| 2| 3| 4|\n| 5| X| 7| 8|\n| 9| O|11|12|\n|13|14|15|16|\nPlease wait, computer thinking of next move...\nComputer moved to space: 7\n| X| 2| 3| 4|\n| 5| X| O| 8|\n| 9| O|11|12|\n|13|14|15|16|\nPlease wait, computer thinking of next move...\nComputer moved to space: 2\n| X| X| 3| 4|\n| 5| X| O| 8|\n| 9| O|11|12|\n|13|14|15|16|\nPlease wait, computer thinking of next move...\nComputer moved to space: 5\n| X| X| 3| 4|\n| O| X| O| 8|\n| 9| O|11|12|\n|13|14|15|16|\nPlease wait, computer thinking of next move...\nComputer moved to space: 3\n| X| X| X| 4|\n| O| X| O| 8|\n| 9| O|11|12|\n|13|14|15|16|\nPlease wait, computer thinking of next move...\nComputer moved to space: 4\n| X| X| X| O|\n| O| X| O| 8|\n| 9| O|11|12|\n|13|14|15|16|\nPlease wait, computer thinking of next move...\nComputer moved to space: 13\n| X| X| X| O|\n| O| X| O| 8|\n| 9| O|11|12|\n| X|14|15|16|\nPlease wait, computer thinking of next move...\nComputer moved to space: 8\n| X| X| X| O|\n| O| X| O| O|\n| 9| O|11|12|\n| X|14|15|16|\nPlease wait, computer thinking of next move...\nComputer moved to space: 9\n| X| X| X| O|\n| O| X| O| O|\n| X| O|11|12|\n| X|14|15|16|\nPlease wait, computer thinking of next move...\nComputer moved to space: 12\n| X| X| X| O|\n| O| X| O| O|\n| X| O|11| O|\n| X|14|15|16|\nPlease wait, computer thinking of next move...\nComputer moved to space: 11\n| X| X| X| O|\n| O| X| O| O|\n| X| O| X| O|\n| X|14|15|16|\nPlease wait, computer thinking of next move...\nComputer moved to space: 16\n| X| X| X| O|\n| O| X| O| O|\n| X| O| X| O|\n| X|14|15| O|\nAIBot2 wins!\nWant to play again?\n Enter 'Y' to play again\n Enter 'N' to exit\nThanks for playing!\n"
  end

  it "game_over also checks to see if user wants to play again" do
    setup_two_draws
    @myio_out.string.should == @initializers_output_human_vs_human + @move_output_9_plus
  end
  
  def setup_two_draws
    @myio_in.string = "1\n3\n1\n1\n2\n2\n99\n3\n5\n4\n6\n8\n7\n9\ny\nn\n3\n1\n3\n1\n2\n2\n1\n5\n4\n8\nn\n"
    start_game
    @move_output_9_plus = "|1|2|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|2|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nCannot move to a space that is already full\n|X|O|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nInvalid input. Please try again.\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|4|O|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|X|O|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|X|O|O|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|X|O|O|\n|7|X|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|X|O|O|\n|O|X|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|X|O|X|\n|X|O|O|\n|O|X|X|\nDraw\nWant to play again?\n Enter 'Y' to play again\n Enter 'N' to exit\nWant to use the same game settings?\n Enter 'Y' to use the same settings\n Enter 'N' to choose new settings\nSelect from the following game rules:\n Enter '1' for standard rules (win by controlling 3 spaces in a row)\n Enter '2' for 2X2 rules (win by controlling a 2X2 block of spaces or 3 in a row)\nInvalid input. Please try again.\nSelect from the following game rules:\n Enter '1' for standard rules (win by controlling 3 spaces in a row)\n Enter '2' for 2X2 rules (win by controlling a 2X2 block of spaces or 3 in a row)\nSelect from the following player options:\n Enter '1' for Computer vs Computer\n Enter '2' for Human vs Computer\n Enter '3' for Human vs Human\n Enter '4' to play a LAN game\nSelect from the following board size choices (rows X columns):\n Enter '1' for 3X3\n Enter '2' for 4X4\n Enter '3' to load a previously saved board\n|1|2|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|1|X|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nCannot move to a space that is already full\n|1|X|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|O|X|3|\n|4|5|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|O|X|3|\n|4|X|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|O|X|3|\n|O|X|6|\n|7|8|9|\nSelect location of next move (or enter 'S' to save board and exit game):\nMove successfully made\n|O|X|3|\n|O|X|6|\n|7|X|9|\nHuman1 wins!\nWant to play again?\n Enter 'Y' to play again\n Enter 'N' to exit\nThanks for playing!\n"
  end
end