require File.dirname(__FILE__) + "/spec_helper"
require 'board'
require 'calculate'
require 'ruby-prof'

describe Calculate do
  before do
    @fail_flag = false
    @num_fails = 0
    @board = Board.new(3,3)
    @num_games = 5
  end

  it "Testing the AI against random moves when the AI moves 1st" do
    while @num_games != 0
      while Calculate.is_game_over?(@board) == false
        if Calculate.current_team(@board) == 1
          ai_move = Calculate.ai_best_move(@board)
          @board.make_move(ai_move, X)
          Calculate.clear_previous_calculations
        else
          move = rand(@board.num_total_spaces)
          while @board.space_contents(move) != EMPTY
            move = rand(@board.num_total_spaces)
          end

          @board.make_move(move, O)
          Calculate.clear_previous_calculations
        end

        if Calculate.win?(@board, O) == true
          @fail_flag = true
        end
      end

      if @fail_flag == true && @num_fails == 0
        @num_fails += 1
        puts "---O Won---"
        @board.draw_board
      end

      @num_games -= 1
      @board.reset
      Calculate.clear_previous_calculations
    end

    @fail_flag.should == false
  end

  it "Testing the AI against random moves when the AI moves 2nd" do
    while @num_games != 0
      while Calculate.is_game_over?(@board) == false
        if Calculate.current_team(@board) == 1
          ai_move = Calculate.ai_best_move(@board)
          @board.make_move(ai_move, O)
          Calculate.clear_previous_calculations
        else
          move = rand(@board.num_total_spaces)
          while @board.space_contents(move) != EMPTY
            move = rand(@board.num_total_spaces)
          end

          @board.make_move(move, X)
          Calculate.clear_previous_calculations
        end

        if Calculate.win?(@board, X) == true
          @fail_flag = true
        end
      end

      if @fail_flag == true && @num_fails == 0
        @num_fails += 1
        puts "---X Won---"
        @board.draw_board
      end

      @num_games -= 1
      @board.reset
      Calculate.clear_previous_calculations
    end

    @fail_flag.should == false
  end
end