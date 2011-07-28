require 'constants'

class Calculate
  class << self
    def what_is_the_other_team(team)
      if team == X
        return O
      elsif team == O
        return X
      else
        return nil
      end
    end

    def is_game_over?(board)
      return X if (check_board_for_win(board) == X)
      return O if (check_board_for_win(board) == O)
      return DRAW if board.is_board_full?
      return false
    end

    def current_team(board)
      current_turn = board.num_moves_made
      if current_turn % 2 == 0
        return X
      else
        return O
      end
    end
    
    def best_move(board, difficulty)
      return easy_difficulty(board) if difficulty == "Easy"
      return medium_difficulty(board) if difficulty == "Medium"
      return hard_difficulty(board)
    end

    private # The rest of the methods in this class are private

    def inspect_all_rows_cols_and_diags(board)
      group_of_cells = []

      board.dim_cols.times do |n|
        group_of_cells.push(check_cell_group(board, lambda {|i| i + (n*board.dim_cols)}))  # Check Row
        group_of_cells.push(check_cell_group(board, lambda {|i| n + (i*board.dim_cols)}))  # Check Col
      end
      group_of_cells.push(check_cell_group(board, lambda {|i| i * (board.dim_cols+1)}))  # Check Forward Diagonal
      group_of_cells.push(check_cell_group(board, lambda {|i| (i+1) * (board.dim_cols-1)}))  # Check Reverse Diagonal

      return group_of_cells
    end

    def check_board_for_win(board)
      group_of_cells = inspect_all_rows_cols_and_diags(board)
      
      group_of_cells.length.times do |i|
        if group_of_cells[i][0] == "win"
          return group_of_cells[i][1]
        end
      end
      
      return nil
    end

    #TODO - split into smaller methods
    def check_cell_group(board, prc)
      num_teams_encountered, empty_spaces_encountered, current_team, space_locations = 0, 0, EMPTY, []

      board.dim_cols.times do |i|
        space_locations.push(prc.call(i))
        if board.space_contents(space_locations[i]) == EMPTY
          empty_spaces_encountered += 1
        else
          if current_team == EMPTY
            current_team = board.space_contents(space_locations[i])  # Set the 1st team encountered to current_team
            num_teams_encountered = 1
          end
          if current_team != board.space_contents(space_locations[i])
            num_teams_encountered += 1
          end
        end
      end

      return analyze_cell_group_data(num_teams_encountered, empty_spaces_encountered, current_team)
    end

    def analyze_cell_group_data(num_teams_encountered, empty_spaces_encountered, current_team)
      if num_teams_encountered == 1 && empty_spaces_encountered == 0
        return ["win", current_team]
      end

      return ["nothing_interesting", 0]
    end
    
    def easy_difficulty(board)
      return minimax(board, 0, 1)
    end
    
    def medium_difficulty(board)
      if board.num_total_spaces == 9
        if board.num_moves_made != 0
          return minimax(board, 0, 4)
        end
      end
      return minimax(board, 0, 3)
    end
    
    def hard_difficulty(board)
      if board.num_total_spaces == 9
        if board.num_moves_made == 0
          return minimax(board, 0, 2)
        else
          return minimax(board, 0, 5)
        end
      elsif board.num_total_spaces == 16
        if board.num_moves_made <= 6
          return minimax(board, 0, 2)
        else
          return minimax(board, 0, 3)
        end
      end
    end
    
    #TODO - split into smaller methods
    def minimax(board, depth, max_depth)
      best_move_location, best_move_minimax_val = nil, -2
      
      return get_end_game_val(board, depth, best_move_location) if is_game_over?(board) != false
      return get_reached_max_depth_val(depth, best_move_location) if depth == (max_depth+1)
      
      if depth <= max_depth
        board.num_total_spaces.times do |location|
          if board.space_contents(location) == EMPTY
            board.make_move(location, current_team(board))

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
      if is_game_over?(board) == DRAW
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
end