require File.expand_path(File.dirname(__FILE__) + "/spec_helper") 
require 'board'
require 'calculate'
require 'ruby-prof'

describe "profiling" do
  before do
    @board = Board.new(3, 3)
  end
  
  it "self.best_move(Board) - returns an array containing the row and column of the best possible next move" do
    RubyProf.start
    # Testing for 1st move
    Calculate.best_move(@board).should == 0
    @board.reset
    
    setup_x_win_on_row
    Calculate.best_move(@board).should == 2
    @board.reset
    
    setup_x_win_on_col
    Calculate.best_move(@board).should == 6
    @board.reset
    
    setup_o_win_on_forward_diag
    Calculate.best_move(@board).should == 8
    @board.reset
    
    setup_o_win_on_reverse_diag
    Calculate.best_move(@board).should == 6
    @board.reset
    
    setup_x_win_choose_best_empty_winner
    Calculate.best_move(@board).should == 3
    @board.reset
    
    setup_kiddie_corner_trap
    move = Calculate.best_move(@board)
    move.should_not == 0
    move.should_not == 8
    move.should < @board.num_total_spaces
    move.should >= 0
    @board.reset
    
    setup_triangle_trap
    move = Calculate.best_move(@board)
    move.should_not == 1
    move.should_not == 3
    move.should_not == 5
    move.should_not == 7
    move.should < @board.num_total_spaces
    move.should >= 0
    @board.reset
    
    setup_corner_trap
    move = Calculate.best_move(@board)
    move.should_not == 3
    move.should_not == 6
    move.should_not == 7
    move.should < @board.num_total_spaces
    move.should >= 0
    @board.reset
    
    setup_opposite_corner_trap
    move = Calculate.best_move(@board)
    move.should_not == 1
    move.should_not == 3
    move.should_not == 5
    move.should_not == 7
    move.should < @board.num_total_spaces
    move.should >= 0
    @board.reset
    
    result = RubyProf.stop

    # Print a flat profile to text
    printer = RubyProf::FlatPrinter.new(result)
    printer.print(File.new("ruby_prof_output.txt", "w"), 0)
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
    @board.make_move(2,X)
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
    @board.make_move(1,O)
    @board.make_move(2,O)
    @board.make_move(4,X)
    @board.make_move(5,X)
    @board.make_move(7,X)
    @board.make_move(8,O)
  end

  def setup_kiddie_corner_trap
    @board.make_move(2,X)
    @board.make_move(4,O)
    @board.make_move(6,X)
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
  
  def setup_opposite_corner_trap
    @board.make_move(0,X)
    @board.make_move(8,O)
  end
end