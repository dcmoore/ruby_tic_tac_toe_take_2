# require File.dirname(__FILE__) + "/spec_helper"
# require 'board'
# require 'calculate'
# require 'ruby-prof'
# 
# describe "random game simulations" do
#   before do
#     @board = Board.new(3,3)
#   end
# 
#   it "Testing the AI against random moves when the AI moves 1st" do
#     run_random_simulations(5, X, O).should == false
#   end
#   
#   it "Testing the AI against random moves when the AI moves 2nd" do
#     run_random_simulations(5, O, X).should == false
#   end
#   
#   def run_random_simulations(num_games, ai_team, rand_team)
#     fail_flag, num_fails = false, 0
#     
#     while num_games != 0
#       while Calculate.is_game_over?(@board) == false
#         if Calculate.current_team(@board) == ai_team
#           ai_move = Calculate.best_move(@board)
#           @board.make_move(ai_move, ai_team)
#           Calculate.clear_previous_calculations
#         else
#           move = rand(@board.num_total_spaces)
#           while @board.space_contents(move) != EMPTY
#             move = rand(@board.num_total_spaces)
#           end
# 
#           @board.make_move(move, rand_team)
#           Calculate.clear_previous_calculations
#         end
# 
#         if Calculate.win?(@board, rand_team) == true
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
#       puts "Game Number: " + num_games.to_s
#       num_games -= 1
#       @board.reset
#       Calculate.clear_previous_calculations
#     end
# 
#     return fail_flag
#   end
# end