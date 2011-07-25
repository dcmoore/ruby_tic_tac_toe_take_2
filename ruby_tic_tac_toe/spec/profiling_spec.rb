require File.expand_path(File.dirname(__FILE__) + "/spec_helper") 
require 'board'
require 'calculate'
require 'ruby-prof'

describe "profiling" do
  before do
    @board = Board.new(3, 3)
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
    best_move.should < @board.num_total_spaces
    best_move.should >= 0
    @board.reset
    
    setup_triangle_trap
    best_move = Calculate.ai_best_move(@board)
    best_move.should_not == 1
    best_move.should_not == 3
    best_move.should_not == 5
    best_move.should_not == 7
    best_move.should < @board.num_total_spaces
    best_move.should >= 0
    @board.reset
    
    setup_corner_trap
    best_move = Calculate.ai_best_move(@board)
    best_move.should_not == 3
    best_move.should_not == 6
    best_move.should_not == 7
    best_move.should < @board.num_total_spaces
    best_move.should >= 0
    @board.reset
    
    @board.make_move(0,X)
    @board.make_move(8,X)
    @board.make_move(4,O)
    Calculate.clear_previous_calculations
    Calculate.ai_best_move(@board)
    
    result = RubyProf.stop

    # Print a flat profile to text
    printer = RubyProf::FlatPrinter.new(result)
    printer.print(File.new("ruby_prof_output.txt", "w"), 0)
  end

  def setup_x_win_on_row
    @board.make_move(0,X)
    @board.make_move(1,X)
    @board.make_move(4,O)
    Calculate.clear_previous_calculations
  end

  def setup_x_win_on_col
    @board.make_move(0,X)
    @board.make_move(3,X)
    @board.make_move(4,O)
    Calculate.clear_previous_calculations
  end

  def setup_o_win_on_forward_diag
    @board.make_move(3,X)
    @board.make_move(0,O)
    @board.make_move(5,X)
    @board.make_move(4,O)
    @board.make_move(7,X)
    Calculate.clear_previous_calculations
  end

  def setup_o_win_on_reverse_diag
    @board.make_move(0,X)
    @board.make_move(2,O)
    @board.make_move(1,X)
    @board.make_move(4,O)
    @board.make_move(5,X)
    Calculate.clear_previous_calculations
  end

  def setup_x_win_choose_best_empty_winner
    @board.make_move(0,O)
    @board.make_move(1,O)
    @board.make_move(6,X)
    @board.make_move(7,X)
    Calculate.clear_previous_calculations
  end

  def setup_kiddie_corner_trap
    @board.make_move(0,X)
    @board.make_move(4,O)
    @board.make_move(8,X)
    Calculate.clear_previous_calculations
  end

  def setup_triangle_trap
    @board.make_move(0,O)
    @board.make_move(4,X)
    @board.make_move(8,X)
    Calculate.clear_previous_calculations
  end

  def setup_corner_trap
    @board.make_move(1,X)
    @board.make_move(5,X)
    @board.make_move(4,O)
    Calculate.clear_previous_calculations
  end
end