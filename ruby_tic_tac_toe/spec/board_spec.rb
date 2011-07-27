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
  
  it "draw_board - outputs the board in its current state" do
    @original_stdout = $stdout
    myio_out = StringIO.new
    $stdout = myio_out
    make_3_moves
    @board.draw_board
    myio_out.string.should == "|X|X| |\n| |O| |\n| | | |\n"
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

  it "convert_space_val_to_graphic - graphically converts 0 to empty space, 1 to X, and 2 to O" do
    @board.convert_space_val_to_graphic(EMPTY).should == " "
    @board.convert_space_val_to_graphic(X).should == "X"
    @board.convert_space_val_to_graphic(O).should == "O"
  end

  it "dup - returns a deep copy of the current board as a new object" do
    make_3_moves
    new_board = @board.dup
    new_board.object_id.should_not == @board.object_id
    @board.make_move(4, EMPTY)
    new_board.space_contents(4).should == O
  end

  it "num_moves_made - returns the number of moves that have been made on the board" do
    make_3_moves
    @board.num_moves_made.should == 3
    @board.reset
  end

  it "is_board_full?(board)" do
    make_9_moves
    @board.is_board_full? == true
    @board.reset

    make_3_moves
    @board.is_board_full? == false
  end

  it "dim_rows - returns the number of rows in the board" do
    @board.dim_rows.should == 3
  end

  it "dim_cols - returns the number of columns in the board" do
    @board.dim_cols.should == 3
  end
  
  it "spaces - should return the hash representing the current" do
    make_3_moves
    arr = [X, X, EMPTY, EMPTY, O, EMPTY, EMPTY, EMPTY, EMPTY]
    @board.spaces.each do |location, team|
      @board.space_contents(location).should == arr[location]
    end
  end


  def make_9_moves
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

  def make_3_moves
    @board.make_move(0,X)
    @board.make_move(1,X)
    @board.make_move(4,O)
  end
end