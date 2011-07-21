require 'constants'
require 'space'

class Calculate
  class << self
        def is_game_over?(board)
          return !(draw?(board) == false && win?(board, X) == false && win?(board, O) == false)
        end

        def draw?(board)
          return !win?(board, X) && !win?(board, O) && board.is_board_full?
        end

        def win?(board, mark)
          return check_board_for_win(board) == mark 
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

          empty_winner, optimized_move = find_best_empty_winner(board, team), optimize_the_algorithm(board)
          return empty_winner if empty_winner
          return optimized_move if optimized_move

          wld = create_wld_array(board, team, team, 0)  # Create a win/loss/draw array
          calculated_move = calculate_best_move(board, wld)

          return calculated_move
        end

        private # The rest of the methods in this class are private

        def find_best_empty_winner(board, team)
          board_copy = board.clone_board
          empty_winners = get_empty_winners_array(board_copy)

          winner = find_first_winning_empty_winner(empty_winners, board_copy, team)
          return winner if winner

          if empty_winners.length != 0
            return empty_winners[0]
          end
          return nil
        end


        def get_empty_winners_array(board)
          group_of_cells = inspect_all_rows_cols_and_diags(board)
          return return_value_of_check_for_empty_winner_method(group_of_cells)
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


        def return_value_of_check_for_empty_winner_method(group_of_cells)
          winners = []
          group_of_cells.length.times do |i|
            if group_of_cells[i][0] == "empty_winner"
              winners.push(group_of_cells[i][1])
            end
          end

          if winners.length != 0
            return winners
          end
          return []
        end


        def find_first_winning_empty_winner(empty_winners, board, team)
          empty_winners.length.times do |i|
            board.make_move(empty_winners[i], team)
            if team == X
              return empty_winners[i] if win?(board, X) == true
            else
              return empty_winners[i] if win?(board, O) == true
            end
            board.make_move(empty_winners[i], EMPTY)
          end
          return nil
        end


        def optimize_the_algorithm(board)
          if board.space_contents(4) == X && board.num_moves_made == 1
            return 0
          end

          if board.space_contents(4) == EMPTY
            return 4
          end

          return nil
        end


        def create_wld_array(board, ai_team, cur_team, depth)
          wld = Hash.new(EMPTY)

          board.num_total_spaces.times do |location|
            wld[location] = 0
            if board.space_contents(location) == EMPTY
              wld, board = fill_out_wld_array(wld, board, location, ai_team, cur_team, depth)
            end
          end

          return wld  # If the loop is over, return this depth's completed wld array
        end


        #TODO - break up into smaller method
        def fill_out_wld_array(wld, board, location, ai_team, cur_team, depth)
          board.make_move(location, current_team(board))  # Make a hypothetical move

          if is_game_over?(board) == true
            wld = update_wld(location, ai_team, board, wld)
            board.make_move(location, EMPTY)  # Take back hypothetical move
            return [wld, board]
          end

          temp_array = create_wld_array(board, ai_team, current_team(board), depth+1)  # Recursively call ai_best_move at 1 more level of depth
          wld = add_recursed_wld_vals(temp_array, wld, board, location)  # Add return value (array) of recursive call to wld array
          board.make_move(location, EMPTY)  # Take back hypothetical move

          return [wld, board]
        end


        def update_wld(location, ai_team, board, wld)
          if win?(board, ai_team) == true
            wld[location] += 1
            wld = weigh_traps(location, ai_team, board, wld, WIN)
          elsif win?(board, ai_team) == false
            wld[location] -= 1
            wld = weigh_traps(location, ai_team, board, wld, LOSS)
          end

          return wld
        end


        def weigh_traps(location, ai_team, board, wld, win_or_loss)
          if find_best_empty_winner(board, ai_team) != nil
            if win_or_loss == WIN
              wld[location] += 4
            elsif win_or_loss == LOSS
              wld[location] -= 12
            end
          end

          return wld
        end


        def add_recursed_wld_vals(temp_array, wld, board, location)
          board.num_total_spaces.times do |i|
            wld[location] += temp_array[i]
          end

          return wld
        end


        def calculate_best_move(board, wld)
          best_move = "n"
          board.num_total_spaces.times do |location|
            if board.space_contents(location) == EMPTY
              best_move = set_a_default_value_if_it_hasnt_already_been_set(best_move, location)
              best_move = find_a_move_better_than_the_default(board, wld, best_move, location)
            end
          end

          return best_move
        end


        def set_a_default_value_if_it_hasnt_already_been_set(best_move, location)
          if best_move == "n"
            best_move = location  # Makes sure that best move by default equals an empty space on the board
          end

          return best_move
        end


        def find_a_move_better_than_the_default(board, wld, best_move, location)
          if  wld[location] > wld[best_move]
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
          num_teams_encountered, empty_spaces_encountered, empty_space_location, current_team, space_locations = 0, 0, 0, EMPTY, []

          board.dim_cols.times do |i|
            space_locations.push(prc.call(i))
            if board.space_contents(space_locations[i]) == EMPTY
              empty_space_location = space_locations[i]
              empty_spaces_encountered += 1
            else
              if current_team == EMPTY
                current_team = board.space_contents(space_locations[i])
                num_teams_encountered = 1
              end
              if current_team != board.space_contents(space_locations[i])
                num_teams_encountered += 1
              end
            end
          end

          return analyze_cell_group_data(num_teams_encountered, empty_spaces_encountered, current_team, empty_space_location)
        end


        def analyze_cell_group_data(num_teams_encountered, empty_spaces_encountered, current_team, empty_space_location)
          if num_teams_encountered == 1 && empty_spaces_encountered == 0
            return ["win", current_team]
          elsif num_teams_encountered == 1 && empty_spaces_encountered == 1
            return ["empty_winner", empty_space_location]
          end

          return ["nothing_interesting", 0]
        end
  end
end