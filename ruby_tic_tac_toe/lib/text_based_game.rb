$: << File.dirname(__FILE__)
require 'board'
require 'calculate'
require 'player'
require 'constants'


class TextBasedGame
    def initialize()
    @board = create_board
    create_players
    if @player1.type == "Computer" || @player2.type == "Computer"
      @difficulty = get_difficulty
    end
  end
  
  
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
    num_players = get_num_players

    if num_players == "1"
      player_factory("Computer", "Computer")
    elsif num_players == "2"
      initialize_with_one_player
    elsif num_players == "3"
      player_factory("Human", "Human")
    end
  end


  def initialize_with_one_player
    input = get_human_players_team

    if input == "X" || input == "x"
      player_factory("Human", "Computer")
    else
      player_factory("Computer", "Human")
    end
  end


  def player_factory(p1, p2)
    @player1 = Player.new(p1)
    @player2 = Player.new(p2)
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


  def get_human_players_team
    input = ""
    while input != "X" && input != "x" && input != "O" && input != "o"
      $stdout.puts "What team do you want to be on? X or O?"
      input = $stdin.gets.chomp
    end

    return input
  end


  def runGame
    while Calculate.is_game_over?(@board) == false
      if Calculate.current_team(@board) == X
        run_xs_turn
      else
        run_os_turn
      end
    end
  end


  def run_xs_turn
    if @player1.type == "Human"
      run_humans_turn(X)
    else
      run_computers_turn(X)
    end
  end


  def run_os_turn
    if @player2.type == "Human"
      run_humans_turn(O)
    else
      run_computers_turn(O)
    end
  end


  def run_computers_turn(team)
    $stdout.puts "Please wait, computer thinking of next move..."
    ai_move = Calculate.best_move(@board, @difficulty)

    if @board.space_contents(ai_move) == EMPTY
      @board.make_move(ai_move, team)
      $stdout.puts "Computer moved to space: " + ai_move.to_s
    end
  end


  def run_humans_turn(team)
    move = get_human_players_move

    if @board.space_contents(move) == EMPTY
      @board.make_move(move, team)
      $stdout.puts "Move successfully made"
    else
      $stdout.puts "Cannot move to a space that is already full"
    end
  end


  def get_human_players_move
    print_board_with_empty_locations
    $stdout.puts "Select location of next move:"
    move = $stdin.gets.chomp.to_i - 1

    return validate_move(move)
  end
  
  
  def print_board_with_empty_locations
    display_block = ""
    
    @board.num_total_spaces.times do |location|
      if @board.space_contents(location) == EMPTY
        display_block += "|" + (location+1).to_s
      else
        display_block += "|" + @board.convert_space_val_to_graphic(@board.space_contents(location))
      end
      if (location % @board.dim_cols) == (@board.dim_cols - 1)
        display_block += "|\n"
      end
    end
    
    puts display_block
  end


  def validate_move(move)
    while !(move.to_i >= 0 && move.to_i < @board.num_total_spaces)
      $stdout.puts "Invalid Move"
      print_board_with_empty_locations
      move = $stdin.gets.chomp
    end

    return move.to_i
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
end


# Run the game --------------------------------------------
if __FILE__ == $0
  game1 = TextBasedGame.new
  game1.runGame
  game1.game_over
end