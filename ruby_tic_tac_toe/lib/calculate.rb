require 'constants'

class Calculate
  class << self
    @@stored_calc = {:check_flag => 0, :igo => false, :drw => false, :xwn => false, :own => false}
    
    def clear_previous_calculations
      @@stored_calc[:check_flag] = 0
    end
    
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
      if @@stored_calc[:check_flag] == 0
        evaluate_board(board)
      end
      return @@stored_calc[:igo]
    end

    def draw?(board)
      if @@stored_calc[:check_flag] == 0
        evaluate_board(board)
      end
      return @@stored_calc[:drw]
    end

    def win?(board, mark)
      if @@stored_calc[:check_flag] == 0
        evaluate_board(board)
      end
      
      if mark == X
        return @@stored_calc[:xwn]
      else
        return @@stored_calc[:own]
      end
    end

    def current_team(board)
      current_turn = board.num_moves_made
      if current_turn % 2 == 0
        return X
      else
        return O
      end
    end
    
    def best_move(board)
      return minimax(board, 0)
    end
    
    def minimax(board, depth)
      best_move_location, best_move_minimax_val, max_depth = nil, -2, 5
      
      if is_game_over?(board) == true
        puts "Game Over"
        puts ""
        if draw?(board) == true
          return minimax_return_value(depth, 0, best_move_location)
        else #Win
          return minimax_return_value(depth, -1, best_move_location)
        end
      end
      if depth == max_depth+1
        return minimax_return_value(depth, 0, best_move_location)
      end
      
      if depth <= max_depth
        board.num_total_spaces.times do |location|
          if board.space_contents(location) == EMPTY
            team = current_team(board)
            board.make_move(location, current_team(board))
            @@stored_calc[:check_flag] = 0
            
            puts "Making move to space: " + location.to_s + " at depth: " + depth.to_s + " with team: " + board.convert_space_val_to_graphic(team)
            board.draw_board
            
            current_space_minimax_val = minimax(board, depth+1) * -1
            puts "Value returned for space " + location.to_s + ": " + current_space_minimax_val.to_s + " at depth: " + depth.to_s
            board.make_move(location, EMPTY)
            @@stored_calc[:check_flag] = 0

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
      
      puts "Board at depth: " + depth.to_s
      board.draw_board
      puts "Best Move value = " + best_move_minimax_val.to_s + " and location = " + best_move_location.to_s
      puts ""
      return minimax_return_value(depth, best_move_minimax_val, best_move_location)
    end
    
    def minimax_return_value(depth, minimax_val, location)
      if depth == 0
        return location
      else
        return minimax_val
      end
    end


    private # The rest of the methods in this class are private
    
    def evaluate_board(board)
      # puts "Evaluating the Board"
      @@stored_calc[:check_flag] = 1
      @@stored_calc[:xwn] = (check_board_for_win(board) == X)
      @@stored_calc[:own] = (check_board_for_win(board) == O)
      @@stored_calc[:drw] = !win?(board, X) && !win?(board, O) && board.is_board_full?
      @@stored_calc[:igo] = !(draw?(board) == false && win?(board, X) == false && win?(board, O) == false)
    end

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
  end
end