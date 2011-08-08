require File.dirname(__FILE__) + "/spec_helper"
require 'tic_tac_toe_board'

describe TicTacToeBoard do
  before do
    @board = TicTacToeBoard.new(3)
  end

  it "get_size - returns the size of the board" do
    @board.get_size.should == 3
  end
  
  it "get_num_spaces - returns the total number of spaces on the board" do
    @board.get_num_spaces.should == 9
  end
  
  it "get_num_moves_made - returns the number of moves that have been made on the board" do
    make_3_moves
    @board.get_num_moves_made.should == 3
    @board.reset
  end

  it "make_move(row, col, team) - updates the game board to reflect a move by the specified team" do
    @board.make_move(0,X)
    @board.space_contents(0).should == X
  end
  
  it "space_contents(row, col) - returns the contents of the specified space" do
    @board.make_move(0,X)
    @board.space_contents(0).should == X
    @board.space_contents(4).should == EMPTY
  end

  it "reset - clears all previous moves from the game board" do
    @board.make_move(0,O)
    @board.reset
    @board.space_contents(0).should == EMPTY
  end

  def make_3_moves
    @board.make_move(0,X)
    @board.make_move(1,X)
    @board.make_move(4,O)
  end
end