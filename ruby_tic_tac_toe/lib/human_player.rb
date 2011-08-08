require 'game_io'
require 'constants'
require 'player'

class HumanPlayer < Player
end

class TextHumanPlayer < HumanPlayer
  def take_turn(board)
    prompt = "Select location of next move (or enter 'S' to save board and exit game):"
    possible_values = lambda{|x| x == "S" || (x.to_i > 0 && x.to_i <= board.get_num_spaces)}
    
    move = TextGameIO.get_valid_input(prompt, possible_values)
    return "EXIT" if move == "S"
    move = move.to_i-1
    
    if board.space_contents(move) == EMPTY
      board.make_move(move, team)
      $stdout.puts "Move successfully made"
    else
      $stdout.puts "Cannot move to a space that is already full"
    end
    
    return board
  end
end

class GUIHumanPlayer < HumanPlayer
  def take_turn(board)
  end
end