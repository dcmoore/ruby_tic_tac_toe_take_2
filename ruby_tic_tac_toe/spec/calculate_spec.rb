require File.dirname(__FILE__) + "/spec_helper"
require 'board'
require 'calculate'
require 'ruby-prof'

describe Calculate do
  before do
    @board = Board.new(3, 3)
  end

  it "self.is_game_over?(Board) - returns true if draw?(), x_win?(), or o_win?() returns true" do
    setup_x_win_on_full_board
    Calculate.is_game_over?(@board).should == true
    @board.reset
  end

  it "self.win?(Board, team) - returns true if the specified team has 3 consecutive spaces in a row" do
    setup_x_win_on_full_board
    Calculate.win?(@board, X).should == true
    @board.reset
    
    setup_o_win_in_three_moves
    Calculate.win?(@board, O).should == true
    @board.reset
  end

  it "self.draw?(Board) - returns true if X and O didn't win and the board is full" do
    setup_draw
    Calculate.draw?(@board).should == true
    @board.reset

    setup_x_win_on_full_board
    Calculate.draw?(@board).should == false
    @board.reset
  end

  it "self.current_team(Board) - returns the team who is next in line to make a move" do
    setup_x_win_choose_best_empty_winner
    Calculate.current_team(@board).should == X
    @board.reset
  end

  it "self.ai_best_move(Board) - returns an array containing the row and column of the best possible next move" do
    RubyProf.start
    # Testing for 1st move
    Calculate.ai_best_move(@board).should == 4
    @board.reset

    setup_x_win_on_row
    Calculate.ai_best_move(@board).should == 2
    @board.reset

    setup_x_win_on_col
    Calculate.ai_best_move(@board).should == 6
    @board.reset

    setup_o_win_on_forward_diag
    Calculate.ai_best_move(@board).should == 8
    @board.reset

    setup_o_win_on_reverse_diag
    Calculate.ai_best_move(@board).should == 6
    @board.reset

    setup_x_win_choose_best_empty_winner
    Calculate.ai_best_move(@board).should == 8
    @board.reset

    setup_kiddie_corner_trap
    best_move = Calculate.ai_best_move(@board)
    best_move.should_not == 2
    best_move.should_not == 6
    @board.reset

    setup_triangle_trap
    best_move = Calculate.ai_best_move(@board)
    best_move.should_not == 1
    best_move.should_not == 3
    best_move.should_not == 5
    best_move.should_not == 7
    @board.reset

    setup_corner_trap
    best_move = Calculate.ai_best_move(@board)
    best_move.should_not == 3
    best_move.should_not == 6
    best_move.should_not == 7
    @board.reset
    
    result = RubyProf.stop

    # Print a flat profile to text
    printer = RubyProf::FlatPrinter.new(result)
    printer.print(File.new("ruby_prof_log.txt", "w"), 0)
  end

  def setup_draw
    @board.make_move(0,X)
    @board.make_move(1,X)
    @board.make_move(2,O)
    @board.make_move(3,O)
    @board.make_move(4,X)
    @board.make_move(5,X)
    @board.make_move(6,X)
    @board.make_move(7,O)
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

  def setup_x_win_on_row
    @board.make_move(0,X)
    @board.make_move(1,X)
    @board.make_move(4,O)
  end

  def setup_x_win_on_col
    @board.make_move(0,X)
    @board.make_move(3,X)
    @board.make_move(4,O)
  end

  def setup_o_win_on_forward_diag
    @board.make_move(3,X)
    @board.make_move(0,O)
    @board.make_move(5,X)
    @board.make_move(4,O)
    @board.make_move(7,X)
  end

  def setup_o_win_on_reverse_diag
    @board.make_move(0,X)
    @board.make_move(2,O)
    @board.make_move(1,X)
    @board.make_move(4,O)
    @board.make_move(5,X)
  end

  def setup_x_win_choose_best_empty_winner
    @board.make_move(0,O)
    @board.make_move(1,O)
    @board.make_move(6,X)
    @board.make_move(7,X)
  end

  def setup_kiddie_corner_trap
    @board.make_move(0,X)
    @board.make_move(4,O)
    @board.make_move(8,X)
  end

  def setup_triangle_trap
    @board.make_move(0,O)
    @board.make_move(4,X)
    @board.make_move(8,X)
  end

  def setup_corner_trap
    @board.make_move(1,X)
    @board.make_move(5,X)
    @board.make_move(4,O)
  end
end