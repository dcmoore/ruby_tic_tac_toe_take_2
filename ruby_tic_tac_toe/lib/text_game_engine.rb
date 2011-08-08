$: << File.dirname(__FILE__)
require 'tic_tac_toe_board'
require 'human_player'
require 'computer_player'
require 'constants'
require 'game_io'
require 'save_load_object'


class TextGameEngine < GameEngine
  def initialize()
    get_settings
    run_game
  end
  
  def get_settings
    get_and_set_rules
    create_and_set_players
    create_and_set_board
  end

  def run_game
    game_status = "CONTINUE"
    
    while is_game_over?(@board, @rules) == false && game_status == "CONTINUE"
      TextGameIO.print_board(@board)
      if current_team(@board) == @player1.team
        move = @player1.take_turn(@board)
      else
        move = @player2.take_turn(@board)
      end
      
      if move == "EXIT"
        game_status = "EXIT"
        save_game
      else
        @board = move
      end
    end
    
    game_over
  end
  
  
  private #------------------------------------------
  
  def create_and_set_players
    num_players_options = get_num_players

    if num_players_options == "1"
      @player1 = TicTacToeComputerPlayer.new(X, "AIBot1", "Easy", @rules)
      @player2 = TicTacToeComputerPlayer.new(O, "AIBot2", "Easy", @rules)
      @player1.set_difficulty(get_difficulty(@player1))
      @player2.set_difficulty(get_difficulty(@player2))
    elsif num_players_options == "2"
      initialize_with_one_player
    elsif num_players_options == "3"
      @player1 = TextHumanPlayer.new(X, "Human1")
      @player2 = TextHumanPlayer.new(O, "Human2")
    elsif num_players_options == "4"
      initialize_LAN_game
    end
  end
  
  def initialize_with_one_player
    input = get_human_players_team

    if input == "X" || input == "x"
      @player1 = TextHumanPlayer.new(X, "Human")
      @player2 = TicTacToeComputerPlayer.new(O, "AIBot", "Easy", @rules)
      @player2.set_difficulty(get_difficulty(@player2))
    else
      @player1 = TicTacToeComputerPlayer.new(X, "AIBot", "Easy", @rules)
      @player1.set_difficulty(get_difficulty(@player1))
      @player2 = TextHumanPlayer.new(O, "Human")
    end
  end
  
  #TODO - change this method to initialize a lan game
  def initialize_LAN_game
    @player1 = TextHumanPlayer.new(X, "Human1")
    @player2 = TextHumanPlayer.new(O, "Human2")
  end
  
  def create_and_set_board
    @board = get_board
  end
  
  def get_and_set_rules
    @rules = get_rules
  end
  
  def get_num_players
    prompt = "Select from the following player options:\n Enter '1' for Computer vs Computer\n Enter '2' for Human vs Computer\n Enter '3' for Human vs Human\n Enter '4' to play a LAN game\n"
    possible_values = lambda{|x| x == "1" || x == "2" || x == "3" || x == "4"}

    return TextGameIO.get_valid_input(prompt, possible_values)
  end

  def get_human_players_team
    prompt = "What team do you want to be on? X or O?"
    possible_values = lambda{|x| x == "X" || x == "x" || x == "O" || x == "o"}

    return TextGameIO.get_valid_input(prompt, possible_values)
  end
  
  def get_difficulty(player)
    prompt = "Select from the following difficulty options for " + player.name + ":\n Enter '1' for Easy\n Enter '2' for Medium\n Enter '3' for Hard\n"
    possible_values = lambda{|x| x == "1" || x == "2" || x == "3"}
    diff =  TextGameIO.get_valid_input(prompt, possible_values)

    return "Easy" if diff == "1"
    return "Medium" if diff == "2"
    return "Hard" if diff == "3"
  end
  
  def get_board
    prompt = "Select from the following board size choices (rows X columns):\n Enter '1' for 3X3\n Enter '2' for 4X4\n Enter '3' to load a previously saved board\n"
    possible_values = lambda{|x| x == "1" || x == "2" || x == "3"}
    option = TextGameIO.get_valid_input(prompt, possible_values)
    
    return TicTacToeBoard.new(3) if option == "1"
    return TicTacToeBoard.new(4) if option == "2"
    return load_saved_board if option == "3"
  end
  
  def load_saved_board
    prompt = "Enter the file name that your board is saved under:"
    possible_values = lambda{|x| SaveLoadObject.file_exists?(x) == true}
    file_name = TextGameIO.get_valid_input(prompt, possible_values)
    
    return SaveLoadObject.load(file_name)
  end
  
  def get_rules
    prompt = "Select from the following game rules:\n Enter '1' for standard rules (win by controlling 3 spaces in a row)\n Enter '2' for 2X2 rules (win by controlling a 2X2 block of spaces or 3 in a row)\n"
    possible_values = lambda{|x| x == "1" || x == "2"}
    rules = TextGameIO.get_valid_input(prompt, possible_values)

    return "rows_cols_diags" if rules == "1"
    return "rows_cols_diags_blocks" if rules == "2"
  end
  
  def save_game
    prompt = "Enter a file name to save your board to:"
    possible_values = lambda{|x| x[/^[A-Za-z0-9]+$/] && SaveLoadObject.file_exists?(x) == false}
    file_name = TextGameIO.get_valid_input(prompt, possible_values)
    
    SaveLoadObject.save(file_name, @board)
  end
  
  def game_over
    TextGameIO.print_board(@board)
    who_won = is_game_over?(@board, @rules)
    if who_won == @player1.team
      $stdout.puts @player1.name + " wins!"
    elsif who_won == @player2.team
      $stdout.puts @player2.name + " wins!"
    elsif who_won == DRAW
      $stdout.puts "Draw"
    end
    
    play_again?
  end
  
  def play_again?
    prompt = "Want to play again?\n Enter 'Y' to play again\n Enter 'N' to exit\n"
    input =  TextGameIO.get_valid_input(prompt, lambda{|x| x == "Y" || x == "y" || x == "N" || x == "n"})
    
    if (input == "y" || input == "Y")
      prompt = "Want to use the same game settings?\n Enter 'Y' to use the same settings\n Enter 'N' to choose new settings\n"
      input =  TextGameIO.get_valid_input(prompt, lambda{|x| x == "Y" || x == "y" || x == "N" || x == "n"})
      
      if input == "y" || input == "Y"
        play_again(true)
      else
        play_again(false)
      end
    else
      $stdout.puts "Thanks for playing!"
    end
  end
  
  def play_again(use_same_settings)
    if use_same_settings == true
      @board.reset
      run_game
    else
      next_game = TextGameEngine.new
    end
  end
end


# Run the game --------------------------------------------
if __FILE__ == $0
  TextGameEngine.new
end