require 'constants'
require 'calculate'

class ComputerPlayer < Player
  def take_turn(board, difficulty)
    $stdout.puts "Please wait, computer thinking of next move..."
    ai_move = ""
    if difficulty == "Easy"
      ai_move = easy_difficulty(board)
    elsif difficulty == "Medium"
      ai_move = medium_difficulty(board)
    else
      ai_move = hard_difficulty(board)
    end
    
    if board.space_contents(ai_move) == EMPTY
      board.make_move(ai_move, team)
      $stdout.puts "Computer moved to space: " + (ai_move+1).to_s
    end
    
    return board
  end
  
  
  private #-----------------------------------
  
  def easy_difficulty(board)
    return get_random_empty_space(board)
  end
  
  def get_random_empty_space(board)
    move = rand(board.num_total_spaces)
    while board.space_contents(move) != EMPTY
      move = rand(board.num_total_spaces)
    end

    return move
  end
  
  def medium_difficulty(board)
    if board.num_total_spaces == 9
      return minimax(board, 0, 4) if board.num_moves_made != 0
    elsif board.num_total_spaces == 16
      return minimax(board, 0, 1) if board.num_moves_made <= 6
    end
    
    return minimax(board, 0, 3)
  end
  
  def hard_difficulty(board)
    if board.num_total_spaces == 9
      return minimax(board, 0, 5) if board.num_moves_made != 0
    elsif board.num_total_spaces == 16
      return minimax(board, 0, 3) if board.num_moves_made >= 6
    end
    
    return minimax(board, 0, 2)
  end
  
  #TODO - split into smaller methods
  def minimax(board, depth, max_depth)
    best_move_location, best_move_minimax_val = nil, -2
    
    return get_end_game_val(board, depth, best_move_location) if Calculate.is_game_over?(board) != false
    return get_reached_max_depth_val(depth, best_move_location) if depth == (max_depth+1)
    
    if depth <= max_depth
      board.num_total_spaces.times do |location|
        if board.space_contents(location) == EMPTY
          board.make_move(location, Calculate.current_team(board))

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
    if Calculate.is_game_over?(board) == DRAW
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

class TextComputerPlayer < ComputerPlayer
end

class GUIComputerPlayer < ComputerPlayer
end