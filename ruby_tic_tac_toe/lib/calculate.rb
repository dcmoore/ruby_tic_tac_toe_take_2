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

    def ai_best_move(board)
      team = current_team(board)
      wld = create_wld_array(board, team, team, 0)  # Create a win/loss/draw array
      
      # puts "--wld--"
      # print_wld(wld, board)
      
      return calculate_best_move(board, wld)
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

    def create_wld_array(board, ai_team, cur_team, depth)
      wld = Hash.new(0)
      
      if depth <= 3
        board.num_total_spaces.times do |location|
          wld[location] = 0
          if board.space_contents(location) == EMPTY
            wld, board = fill_out_wld_array(wld, board, location, ai_team, cur_team, depth)
            wld = lookout_for_traps(wld, depth, board, ai_team, location)
          end
        end
      end

      return wld  # If the loop is over, return this depth's completed wld array
    end
    
    def lookout_for_traps(wld, depth, board, ai_team, location)
      if wld.values.inject{|sum,x| sum + x } == -2 && depth == 3 && ((board.space_contents(4) == ai_team && !(board.space_contents(7) == ai_team)) || (board.space_contents(4) == what_is_the_other_team(ai_team) && !(board.space_contents(6) == ai_team)))
        wld[location] -= 99
      end
      
      return wld
    end

    #TODO - break up into smaller method
    def fill_out_wld_array(wld, board, location, ai_team, cur_team, depth)
      @@stored_calc[:check_flag] = 0
      board.make_move(location, current_team(board))  # Make a hypothetical move
      # puts "Making Move at Depth: " + depth.to_s
      # board.draw_board

      if is_game_over?(board) == true
        wld = update_wld(location, ai_team, board, wld, depth)
        @@stored_calc[:check_flag] = 0
        board.make_move(location, EMPTY)  # Take back hypothetical move
        
        # puts "WLD at depth: " + depth.to_s
        # print_wld(wld, board)
        
        return [wld, board]
      end

      temp_array = create_wld_array(board, ai_team, current_team(board), depth+1)  # Recursively call ai_best_move at 1 more level of depth
      wld = add_recursed_wld_vals(temp_array, wld, board, location)  # Add return value (array) of recursive call to wld array
      @@stored_calc[:check_flag] = 0
      board.make_move(location, EMPTY)  # Take back hypothetical move
      
      # puts "WLD at depth: " + depth.to_s
      # print_wld(wld, board)
      
      return [wld, board]
    end

    def update_wld(location, ai_team, board, wld, depth)
      if win?(board, ai_team) == true
        wld = add_wld_points(WIN, location, depth, wld)
      elsif win?(board, what_is_the_other_team(ai_team)) == true
        wld = add_wld_points(LOSS, location, depth, wld)
      end

      return wld
    end
    
    def add_wld_points(win_or_loss, location, depth, wld)
      points = 0
      case
        when depth == 0 then points += 1111
        when depth == 1 then points += 111
        when depth == 2 then points += 11
        when depth == 3 then points += 1
      end
      
      if win_or_loss == LOSS
        points *= -1
      end

      wld[location] += points
      return wld
    end

    def add_recursed_wld_vals(temp_array, wld, board, location)
      board.num_total_spaces.times do |i|
        wld[location] += temp_array[i]
      end

      return wld
    end

    def calculate_best_move(board, wld)
      best_move = nil
      board.num_total_spaces.times do |location|
        if board.space_contents(location) == EMPTY
          best_move = set_a_default_value_if_it_hasnt_already_been_set(best_move, location)
          best_move = find_a_move_better_than_the_default(board, wld, best_move, location)
        end
      end

      return best_move
    end

    def set_a_default_value_if_it_hasnt_already_been_set(best_move, location)
      if best_move == nil
        best_move = location  # Makes sure that best move by default equals an empty space on the board
      end

      return best_move
    end

    def find_a_move_better_than_the_default(board, wld, best_move, location)
      if location == 4
        wld[location] += 1  # Give tie-breaker to center space
      end
      
      if wld[location] > wld[best_move]
        best_move = location
      end

      return best_move
    end

    def check_board_for_win(board)
      group_of_cells = inspect_all_rows_cols_and_diags(board)
      return return_value_of_check_for_win_method(group_of_cells)
    end

    def return_value_of_check_for_win_method(group_of_cells)
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
    
    def print_wld(wld, board)
      display_block = ""

      board.num_total_spaces.times do |location|
        display_block += "|" + wld[location].to_s
        if (location % board.dim_cols) == (board.dim_cols - 1)
          display_block += "|\n"
        end
      end

      puts display_block
    end
  end
end