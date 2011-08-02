require File.dirname(__FILE__) + "/spec_helper"
require 'board'

describe Board do
  before do
    @board = Board.new(3, 3)
  end

  it "make_move(row, col, team) - updates the game board to reflect a move by the specified team" do
    @board.make_move(0,X)
    @board.space_contents(0).should == X
  end
  
  it "num_total_spaces - returns the toal number of spaces (empty or full) on the board" do
    @board.num_total_spaces.should == 9
  end
  
  it "print_board - outputs the board in its current state" do
    @original_stdout = $stdout
    myio_out = StringIO.new
    $stdout = myio_out
    make_3_moves
    @board.print_board
    myio_out.string.should == "|X|X| |\n| |O| |\n| | | |\n"
    $stdout.close
    $stdout = @original_stdout
  end
  
  it "print_board_with_empty_locations - outputs the board in its current state with locations where empty spaces are" do
    @original_stdout = $stdout
    myio_out = StringIO.new
    $stdout = myio_out
    make_3_moves
    @board.print_board_with_empty_locations
    myio_out.string.should == "|X|X|3|\n|4|O|6|\n|7|8|9|\n"
    $stdout.close
    $stdout = @original_stdout
  end

  it "reset - clears all previous moves from the game board" do
    @board.make_move(0,O)
    @board.reset
    @board.space_contents(0).should == EMPTY
  end

  it "space_contents(row, col) - returns the contents of the specified space" do
    @board.make_move(0,X)
    @board.space_contents(0).should == X
    @board.space_contents(4).should == EMPTY
  end

  it "num_moves_made - returns the number of moves that have been made on the board" do
    make_3_moves
    @board.num_moves_made.should == 3
    @board.reset
  end

  it "dim_rows - returns the number of rows in the board" do
    @board.dim_rows.should == 3
  end

  it "dim_cols - returns the number of columns in the board" do
    @board.dim_cols.should == 3
  end

  def make_3_moves
    @board.make_move(0,X)
    @board.make_move(1,X)
    @board.make_move(4,O)
  end
end