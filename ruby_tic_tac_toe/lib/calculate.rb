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
    

    #private # The rest of the methods in this class are private

    def check_board_for_win(board)
      return check_cell_groups_for_win(board, get_all_groups_of_cells(board))
    end
        
    def get_all_groups_of_cells(board)
      group_of_cells = []

      group_of_cells.concat(get_all_rows_and_cols(board))
      group_of_cells.concat(get_all_diags(board))
      group_of_cells.concat(get_all_blocks(board))
      
      return group_of_cells
    end
    
    def get_all_rows_and_cols(board)
      group_container, rows_group, cols_group = [], [], []
      
      board.dim_cols.times do |n|
        board.dim_cols.times do |i|
          rows_group.push(i + (n*board.dim_cols))
          cols_group.push(n + (i*board.dim_cols))
        end
        
        group_container.push(rows_group)
        group_container.push(cols_group)
        rows_group, cols_group = [], []
      end
      
      return group_container
    end
    
    def get_all_diags(board)
      group_container, forward_diag_group, reverse_diag_group = [], [], []
      
      board.dim_rows.times do |i|
        forward_diag_group.push(i * (board.dim_cols+1))
        reverse_diag_group.push((i+1) * (board.dim_cols-1))
      end
      
      group_container.push(forward_diag_group)
      group_container.push(reverse_diag_group)
      forward_diag_group, reverse_diag_group = [], []
      
      return group_container
    end
    
    def get_all_blocks(board)
      group_container, block_group, block_size = [], [], 4
      num_blocks = (board.dim_rows-1) * (board.dim_cols-1)
      num_blocks.times do |block_num|
        first_block_location = find_block_location(block_num, board)
        block_size.times do |number_in_block|
          block_group.push(get_block_cell(first_block_location, number_in_block, board))
        end
        group_container.push(block_group)
        block_group = []
      end
      
      return group_container
    end
    
    def find_block_location(block_num, board)
      if block_num < ((1*board.dim_cols)-1)
        return block_num
      elsif block_num < ((2*board.dim_cols)-2)
        return block_num+1
      elsif block_num < ((3*board.dim_cols)-2)
        return block_num+2
      end
    end
    
    def get_block_cell(first_cell_location, number_in_block, board)
      return first_cell_location if number_in_block == 0
      return first_cell_location+1 if number_in_block == 1
      return first_cell_location+board.dim_rows if number_in_block == 2
      return first_cell_location+board.dim_rows+1 if number_in_block == 3
    end

    #TODO - split into smaller methods
    def check_cell_groups_for_win(board, collection_of_cell_groups)
      collection_of_cell_groups.each do |current_cell_group|
        num_teams_encountered, empty_spaces_encountered, current_team = 0, 0, EMPTY
        
        current_cell_group.length.times do |i|
          if board.space_contents(current_cell_group[i]) == EMPTY
            empty_spaces_encountered += 1
          else
            if current_team == EMPTY
              current_team = board.space_contents(current_cell_group[i])  # Set the 1st team encountered to current_team
              num_teams_encountered = 1
            end
            if current_team != board.space_contents(current_cell_group[i])
              num_teams_encountered += 1
            end
          end
        end
          
        return current_team if num_teams_encountered == 1 && empty_spaces_encountered == 0
      end

      return nil
    end
    
    def is_board_full?(board)
      if board.num_moves_made == board.num_total_spaces
        return true
      end

      return false
    end
  end
end