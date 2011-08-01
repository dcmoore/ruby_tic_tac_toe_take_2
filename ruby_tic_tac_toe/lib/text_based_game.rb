$: << File.dirname(__FILE__)
require 'board'
require 'calculate'
require 'player'
require 'human_player'
require 'computer_player'
require 'constants'


class TextBasedGame
  def initialize()
    @board = create_board
    create_players
    if @player1.class == TextComputerPlayer || @player2.class == TextComputerPlayer
      @difficulty = get_difficulty
    end
  end
  
  def run_game
    while Calculate.is_game_over?(@board) == false
      if Calculate.current_team(@board) == X
        run_turn(X)
      else
        run_turn(O)
      end
    end
  end
  
  def run_turn(team)
    if @player1.team == team
      if @player1.class == TextHumanPlayer
        @board = @player1.take_turn(@board)
      elsif @player1.class == TextComputerPlayer
        @board = @player1.take_turn(@board, @difficulty)
      end
    else
      if @player2.class == TextHumanPlayer
        @board = @player2.take_turn(@board)
      elsif @player2.class == TextComputerPlayer
        @board = @player2.take_turn(@board, @difficulty)
      end
    end
  end
  
  def game_over
    if Calculate.is_game_over?(@board) == X
      $stdout.puts "X wins!"
    elsif Calculate.is_game_over?(@board) == O
      $stdout.puts "O wins!"
    elsif Calculate.is_game_over?(@board) == DRAW
      $stdout.puts "Draw"
    end
  end
  
  
  private #------------------------------------------
  
  def get_difficulty
    diff = ""
    while diff != "1" && diff != "2" && diff != "3"
      $stdout.puts "Select from the following difficulty options:"
      $stdout.puts " Enter \'1\' for Easy"
      $stdout.puts " Enter \'2\' for Medium"
      $stdout.puts " Enter \'3\' for Hard"
      diff = $stdin.gets.chomp
    end
    return "Easy" if diff == "1"
    return "Medium" if diff == "2"
    return "Hard" if diff == "3"
  end


  def create_board
    size = get_size_of_board
    rows = size
    cols = rows
    @board = Board.new(rows, cols)
    return @board
  end
  
  
  def get_size_of_board
    size = ""
    while size != "1" && size != "2"
      $stdout.puts "Select from the following board size choices (rows X columns):"
      $stdout.puts " Enter \'1\' for 3X3"
      $stdout.puts " Enter \'2\' for 4X4"
      size = $stdin.gets.chomp
    end
    return 3 if size == "1"
    return 4 if size == "2"
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
    num_players = 0
    while num_players != "1" && num_players != "2" && num_players != "3"
      $stdout.puts "Select from the following player options:"
      $stdout.puts " Enter \'1\' for Computer vs Computer"
      $stdout.puts " Enter \'2\' for Human vs Computer"
      $stdout.puts " Enter \'3\' for Human vs Human"
      num_players = $stdin.gets.chomp
    end

    return num_players
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
end


# Run the game --------------------------------------------
if __FILE__ == $0
  game1 = TextBasedGame.new
  game1.run_game
  game1.game_over
end