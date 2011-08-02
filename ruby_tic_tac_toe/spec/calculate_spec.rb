require File.dirname(__FILE__) + "/spec_helper"
require 'board'
require 'calculate'
require 'ruby-prof'

describe Calculate do
  before do
    @board = Board.new(3, 3)
  end
  
  it "what_is_the_other_team(team) - returns 1 if team = 2, returns 2 if team = 1" do
    Calculate.what_is_the_other_team(X).should == O
  end

  it "self.is_game_over?(Board) - returns 1 if X wins, returns 2 if O wins, returns 5 if it is a DRAW, and returns false if none of that happens" do
    setup_x_win_on_full_board
    Calculate.is_game_over?(@board).should_not == false
    @board.reset
    
    setup_x_win_on_full_board
    Calculate.is_game_over?(@board).should == X
    @board.reset
    
    setup_o_win_in_three_moves
    Calculate.is_game_over?(@board).should == O
    @board.reset

    setup_draw
    Calculate.is_game_over?(@board).should == DRAW
    @board.reset
    
    Calculate.is_game_over?(@board).should == false
  end

  it "self.current_team(Board) - returns the team who is next in line to make a move" do
    setup_x_win_choose_best_empty_winner
    Calculate.current_team(@board).should == X
    @board.reset
  end

  def setup_draw
    @board.make_move(0,X)
    @board.make_move(1,O)
    @board.make_move(2,X)
    @board.make_move(3,O)
    @board.make_move(4,O)
    @board.make_move(5,X)
    @board.make_move(6,X)
    @board.make_move(7,X)
    @board.make_move(8,O)
  end

  def setup_x_win_on_full_board
    @board.make_move(0,X)
    @board.make_move(1,O)
    @board.make_move(2,X)
    @board.make_move(3,O)
    @board.make_move(4,X)
    @board.make_move(5,O)
    @board.make_move(6,X)
    @board.make_move(7,O)
    @board.make_move(8,X)
  end

  def setup_o_win_in_three_moves
    @board.make_move(0,O)
    @board.make_move(3,O)
    @board.make_move(6,O)
  end

  def setup_x_win_choose_best_empty_winner
    @board.make_move(0,O)
    @board.make_move(1,O)
    @board.make_move(6,X)
    @board.make_move(7,X)
  end
end