# require File.dirname(__FILE__) + "/spec_helper"
# require 'tic_tac_toe_board'
# require 'game_engine'
# require 'computer_player'
# 
# describe "random game simulations" do
#   before do
#     @board = TicTacToeBoard.new(4)
#     @game_logic = GameEngine.new
#     @difficulty = "Hard"
#     @rules = "rows_cols_diags_blocks"
#     @ai_X = TicTacToeComputerPlayer.new(X, "AIBot1", @difficulty, @rules)
#     @ai_O = TicTacToeComputerPlayer.new(O, "AIBot2", @difficulty, @rules)
#   end
# 
#   it "Testing the AI against random moves when the AI moves 1st" do
#     run_random_simulations(50, X, O).should == false
#   end
#   
#   it "Testing the AI against random moves when the AI moves 2nd" do
#     run_random_simulations(50, O, X).should == false
#   end
#   
#   def run_random_simulations(num_games, ai_team, rand_team)
#     fail_flag, num_fails = false, 0
#     
#     while num_games != 0
#       while @game_logic.is_game_over?(@board, @rules) == false
#         if @game_logic.current_team(@board) == ai_team
#           if ai_team == @ai_X.team
#             @board = @ai_X.take_turn(@board)
#           else
#             @board = @ai_O.take_turn(@board)
#           end
#         else
#           move = rand(@board.get_num_spaces)
#           while @board.space_contents(move) != EMPTY
#             move = rand(@board.get_num_spaces)
#           end
# 
#           @board.make_move(move, rand_team)
#         end
# 
#         if @game_logic.is_game_over?(@board, @rules) == rand_team
#           fail_flag = true
#         end
#       end
# 
#       if fail_flag == true && num_fails == 0
#         num_fails += 1
#         puts "---Random Moves Won---"
#         @board.draw_board
#       end
# 
#       puts "Finished Game Number: " + num_games.to_s
#       num_games -= 1
#       @board.reset
#     end
# 
#     return fail_flag
#   end
# end