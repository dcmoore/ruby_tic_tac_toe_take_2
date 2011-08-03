$: << File.dirname(__FILE__)
require 'board'
require 'calculate'
require 'player'
require 'human_player'
require 'computer_player'
require 'constants'


class TextBasedGame
  def initialize()
    @board = create_and_return_board
    create_players
    if @player1.class == TextComputerPlayer || @player2.class == TextComputerPlayer
      @difficulty = get_difficulty
    end
    @rules = get_rules
  end
  
  def run_game
    game_status = "CONTINUE"
    
    while Calculate.is_game_over?(@board, @rules) == false && game_status == "CONTINUE"
      @board.print_board_with_empty_locations
      if Calculate.current_team(@board) == @player1.team
        game_status = run_turn(@player1)
      else
        game_status = run_turn(@player2)
      end
    end
  end
  
  def run_turn(player)
    if player.class == TextHumanPlayer
      move = player.take_turn(@board)
      return "EXIT" if move == "EXIT"
      @board = move
    elsif player.class == TextComputerPlayer
      @board = player.take_turn(@board, @difficulty, @rules)
    end
    
    return "CONTINUE"
  end
  
  def game_over
    @board.print_board_with_empty_locations
    who_won = Calculate.is_game_over?(@board, @rules)
    if who_won == X
      $stdout.puts "X wins!"
    elsif who_won == O
      $stdout.puts "O wins!"
    elsif who_won == DRAW
      $stdout.puts "Draw"
    end
    $stdout.puts "Thanks for playing!"
  end
  
  
  private #------------------------------------------

  def create_and_return_board
    @board = get_board
    return @board
  end
  
  def get_board
    prompt = "Select from the following board size choices (rows X columns):\n Enter '1' for 3X3\n Enter '2' for 4X4\n Enter '3' to load a previously saved board\n"
    possible_values = ["1", "2", "3"]
    option = get_input(prompt, possible_values)
    
    return Board.new(3,3) if option == "1"
    return Board.new(4,4) if option == "2"
    return get_saved_board if option == "3"
  end
  
  def get_saved_board
    file_name, loaded_board = "", nil
    
    while file_exists(file_name) == false
      $stdout.puts "Enter the file name to your previously saved game:"
      file_name = $stdin.gets.chomp
    end
    
    File.open("temp/" + file_name.to_s + "_save_game.txt","rb") {|f| loaded_board = Marshal.load(f)}
    return loaded_board
  end
  
  def file_exists(file_name) 
    is_valid = File.exist?("temp/" + file_name.to_s + "_save_game.txt")
    if is_valid == false && file_name != ""
      $stdout.puts "Invalid File Name"
    end
    
    return is_valid
  end

  def create_players
    num_players_options = get_num_players

    if num_players_options == "1"
      @player1 = TextComputerPlayer.new(X)
      @player2 = TextComputerPlayer.new(O)
    elsif num_players_options == "2"
      initialize_with_one_player
    elsif num_players_options == "3"
      @player1 = TextHumanPlayer.new(X)
      @player2 = TextHumanPlayer.new(O)
    end
  end
  
  def get_num_players
    prompt = "Select from the following player options:\n Enter '1' for Computer vs Computer\n Enter '2' for Human vs Computer\n Enter '3' for Human vs Human\n"
    possible_values = ["1", "2", "3"]

    return get_input(prompt, possible_values)
  end

  def initialize_with_one_player
    input = get_human_players_team

    if input == "X" || input == "x"
      @player1 = TextHumanPlayer.new(X)
      @player2 = TextComputerPlayer.new(O)
    else
      @player1 = TextComputerPlayer.new(X)
      @player2 = TextHumanPlayer.new(O)
    end
  end

  def get_human_players_team
    input = ""
    while input != "X" && input != "x" && input != "O" && input != "o"
      $stdout.puts "What team do you want to be on? X or O?"
      input = $stdin.gets.chomp
    end

    return input
  end
  
  def get_difficulty
    prompt = "Select from the following difficulty options:\n Enter '1' for Easy\n Enter '2' for Medium\n Enter '3' for Hard\n"
    possible_values = ["1", "2", "3"]

    diff =  get_input(prompt, possible_values)

    return "Easy" if diff == "1"
    return "Medium" if diff == "2"
    return "Hard" if diff == "3"
  end
  
  def get_rules
    prompt = "Select from the following game rules:\n Enter '1' for standard rules (win by controlling 3 spaces in a row)\n Enter '2' for 2X2 rules (win by controlling a 2X2 block of spaces or 3 in a row)\n"
    possible_values = ["1", "2", "2"]

    rules =  get_input(prompt, possible_values)

    return "rows_cols_diags" if rules == "1"
    return "rows_cols_diags_blocks" if rules == "2"
  end
  
  def get_input(prompt, possible_values)
    val = ""
    
    while val != possible_values[0] && val != possible_values[1] && val != possible_values[2]
      $stdout.puts prompt
      val = $stdin.gets.chomp
    end
    
    return val
  end
end


# Run the game --------------------------------------------
if __FILE__ == $0
  game1 = TextBasedGame.new
  game1.run_game
  game1.game_over
end