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
      return DRAW if is_board_full?(board)
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
    
    def is_board_full?(board)
      if board.num_moves_made == board.num_total_spaces
        return true
      end

      return false
    end
  end
end