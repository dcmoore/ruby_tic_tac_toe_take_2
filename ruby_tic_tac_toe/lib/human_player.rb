require 'game_io'
require 'constants'
require 'player'

class HumanPlayer < Player
end

class TextHumanPlayer < HumanPlayer
  def get_move(board)
    prompt = "Select location of next move (or enter 'S' to save board and exit game):"
    possible_values = lambda{|x| x == "S" || (x.to_i > 0 && x.to_i <= board.get_num_spaces)}
    
    move = TextGameIO.get_valid_input(prompt, possible_values)
    return "EXIT" if move == "S"
    return move.to_i-1
  end
end

class GUIHumanPlayer < HumanPlayer
  def take_turn(board)
  end
end