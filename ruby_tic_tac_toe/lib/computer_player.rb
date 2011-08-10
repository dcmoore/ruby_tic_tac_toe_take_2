require 'constants'
require 'game_engine'
require 'player'

class ComputerPlayer < Player
  def initialize(t, n, d, r)
    @team = t
    @name = n
    @difficulty = d
    @rules = r
    @game_logic = GameEngine.new
  end
  
  def set_difficulty(d)
    @difficulty = d
  end
  
  def set_rules(r)
    @rules = r
  end
    
  def get_move(board)
    ai_move = ""
    if @difficulty == "Easy"
      ai_move = easy_difficulty(board)
    elsif @difficulty == "Medium"
      ai_move = medium_difficulty(board)
    else
      ai_move = hard_difficulty(board)
    end
    
    return ai_move
  end
  
  def easy_difficulty(board)
    return get_random_empty_space(board)
  end
  
  def get_random_empty_space(board)
    move = rand(board.get_num_spaces)
    while board.space_contents(move) != EMPTY
      move = rand(board.get_num_spaces)
    end

    return move
  end
  
  def medium_difficulty(board)
    if board.get_num_spaces == 9
      return minimax(board, 0, 4) if board.get_num_moves_made != 0
    elsif board.get_num_spaces == 16
      return minimax(board, 0, 1) if board.get_num_moves_made <= 6
    end
    
    return minimax(board, 0, 3)
  end
  
  def hard_difficulty(board)
    if board.get_num_spaces == 9
      return minimax(board, 0, 5) if board.get_num_moves_made != 0
    elsif board.get_num_spaces == 16
      return minimax(board, 0, 3) if board.get_num_moves_made >= 6
    end
    
    return minimax(board, 0, 2)
  end
  
  #TODO - split into smaller methods
  def minimax(board, depth, max_depth)
    best_move_location, best_move_minimax_val = nil, -2
    
    return get_end_game_val(board, depth, best_move_location) if @game_logic.is_game_over?(board, @rules) != false
    return get_reached_max_depth_val(depth, best_move_location) if depth == (max_depth+1)
    
    if depth <= max_depth
      board.get_num_spaces.times do |location|
        if board.space_contents(location) == EMPTY
          board.make_move(location, @game_logic.current_team(board))

          current_space_minimax_val = minimax(board, depth+1, max_depth) * -1
          board.make_move(location, EMPTY)

          if current_space_minimax_val > best_move_minimax_val
            best_move_minimax_val = current_space_minimax_val
            best_move_location = location
            if best_move_minimax_val == 1
              return minimax_return_value(depth, 1, best_move_location)
            end
          end
        end
      end
    end
    
    return minimax_return_value(depth, best_move_minimax_val, best_move_location)
  end
  
  def get_end_game_val(board, depth, best_move_location)
    if @game_logic.is_game_over?(board, @rules) == DRAW
      return minimax_return_value(depth, 0, best_move_location)
    else #Win
      return minimax_return_value(depth, -1, best_move_location)
    end
  end
  
  def get_reached_max_depth_val(depth, best_move_location)
    return minimax_return_value(depth, 0, best_move_location)
  end
  
  def minimax_return_value(depth, minimax_val, location)
    if depth == 0
      return location
    else
      return minimax_val
    end
  end
end



class TicTacToeComputerPlayer < ComputerPlayer
  def hard_difficulty(board)    
    if board.get_num_spaces == 9
      return minimax(board, 0, 5) if board.get_num_moves_made != 0
    elsif board.get_num_spaces == 16
      if board.get_num_moves_made <= 3 && @rules == "rows_cols_diags_blocks"
        return get_best_empty_middle_space(board)
      elsif board.get_num_moves_made >= 4 && board.get_num_moves_made <= 8
        return minimax(board, 0, 3)
      end
    end

    return minimax(board, 0, 2)
  end
  
  def get_best_empty_middle_space(board)
    if board.space_contents(10) == @game_logic.what_is_the_other_team(@team)
      return 6 if board.space_contents(6) == EMPTY
      return 9 if board.space_contents(9) == EMPTY
    elsif board.space_contents(9) == @game_logic.what_is_the_other_team(@team)
      return 5 if board.space_contents(5) == EMPTY
      return 10 if board.space_contents(10) == EMPTY
    elsif board.space_contents(6) == @game_logic.what_is_the_other_team(@team)
      return 5 if board.space_contents(5) == EMPTY
      return 10 if board.space_contents(10) == EMPTY
    elsif board.space_contents(5) == @game_logic.what_is_the_other_team(@team)
      return 6 if board.space_contents(6) == EMPTY
      return 9 if board.space_contents(9) == EMPTY
    end
    
    if board.space_contents(10) == @game_logic.what_is_the_other_team(@team) && board.space_contents(9) == @game_logic.what_is_the_other_team(@team)
      return 11
    elsif board.space_contents(9) == @game_logic.what_is_the_other_team(@team) && board.space_contents(5) == @game_logic.what_is_the_other_team(@team)
      return 13
    elsif board.space_contents(5) == @game_logic.what_is_the_other_team(@team) && board.space_contents(6) == @game_logic.what_is_the_other_team(@team)
      return 4
    elsif board.space_contents(6) == @game_logic.what_is_the_other_team(@team) && board.space_contents(10) == @game_logic.what_is_the_other_team(@team)
      return 2
    end
    
    return minimax(board, 0, 2)
  end
end

class TextComputerPlayer < ComputerPlayer
end

class GUIComputerPlayer < ComputerPlayer
end