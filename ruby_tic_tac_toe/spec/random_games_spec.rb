# require File.dirname(__FILE__) + "/spec_helper"
# require 'board'
# require 'calculate'
# require 'ruby-prof'
# 
# describe "random game simulations" do
#   before do
#     @board = Board.new(3,3)
#     @difficulty = "Hard"
#     @rules = "rows_cols_diags"
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
#       while Calculate.is_game_over?(@board, @rules) == false
#         if Calculate.current_team(@board) == ai_team
#           ai_move = Calculate.best_move(@board, @difficulty)
#           @board.make_move(ai_move, ai_team)
#         else
#           move = rand(@board.num_total_spaces)
#           while @board.space_contents(move) != EMPTY
#             move = rand(@board.num_total_spaces)
#           end
# 
#           @board.make_move(move, rand_team)
#         end
# 
#         if Calculate.is_game_over?(@board, @rules) == rand_team
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