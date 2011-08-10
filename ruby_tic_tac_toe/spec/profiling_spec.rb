require File.expand_path(File.dirname(__FILE__) + "/spec_helper") 
require 'tic_tac_toe_board'
require 'computer_player'
# require 'ruby-prof'

describe "profiling" do
  before do
    @board = TicTacToeBoard.new(3)
    @ai_playerX = TicTacToeComputerPlayer.new(X, "Steve", "Hard", "rows_cols_diags")
    @ai_playerO = TicTacToeComputerPlayer.new(O, "Jerry", "Hard", "rows_cols_diags")
    @original_stdout = $stdout
    @myio_out = StringIO.new
    $stdout = @myio_out
  end
  
  after do
    $stdout.close
    $stdout = @original_stdout
  end
  
  it "ComputerPlayer.get_move(Board) - returns the location of the best possible next move at the specified difficulty" do
    @ai_playerX.set_difficulty("Easy")
    move = @ai_playerX.get_move(@board)
    move.should < @board.get_num_spaces
    move.should >= 0
    move = @ai_playerX.get_move(TicTacToeBoard.new(4))
    move.should < 16
    move.should >= 0
    
    @ai_playerX.set_difficulty("Medium")
    move.should < @board.get_num_spaces
    move.should >= 0
    move = @ai_playerX.get_move(TicTacToeBoard.new(4))
    move.should < 16
    move.should >= 0
  end
  
  it "ComputerPlayer.get_move(Board, Hard) - testing this method with the hard difficulty turned on" do
    @ai_playerX.set_difficulty("Hard")
    
    # RubyProf.start
    # Testing for 1st move
    @board.make_move(@ai_playerX.get_move(@board), X)
    @board.space_contents(0).should == X
    @board.reset
    
    setup_x_win_on_row
    @board.make_move(@ai_playerO.get_move(@board), O)
    @board.space_contents(2).should == O
    @board.reset
    
    setup_x_win_on_col
    @board.make_move(@ai_playerO.get_move(@board), O)
    @board.space_contents(6).should == O
    @board.reset
    
    setup_o_win_on_forward_diag
    @board.make_move(@ai_playerO.get_move(@board), O)
    @board.space_contents(8).should == O
    @board.reset
    
    setup_o_win_on_reverse_diag
    @board.make_move(@ai_playerO.get_move(@board), O)
    @board.space_contents(6).should == O
    @board.reset
    
    setup_x_win_choose_best_empty_winner
    @board.make_move(@ai_playerX.get_move(@board), X)
    @board.space_contents(3).should == X
    @board.reset
    
    setup_kiddie_corner_trap
    @board.make_move(@ai_playerO.get_move(@board), O)
    @board.space_contents(0).should_not == O
    @board.space_contents(8).should_not == O
    @board.reset
    
    setup_triangle_trap
    @board.make_move(@ai_playerO.get_move(@board), O)
    @board.space_contents(1).should_not == O
    @board.space_contents(3).should_not == O
    @board.space_contents(5).should_not == O
    @board.space_contents(7).should_not == O
    @board.reset
    
    setup_corner_trap
    @board.make_move(@ai_playerO.get_move(@board), O)
    @board.space_contents(3).should_not == O
    @board.space_contents(6).should_not == O
    @board.space_contents(7).should_not == O
    @board.reset
    
    setup_opposite_corner_trap
    @board.make_move(@ai_playerO.get_move(@board), O)
    @board.space_contents(1).should_not == O
    @board.space_contents(3).should_not == O
    @board.space_contents(5).should_not == O
    @board.space_contents(7).should_not == O
    @board.reset
    
    # result = RubyProf.stop
    # 
    # # Print a flat profile to text
    # printer = RubyProf::FlatPrinter.new(result)
    # printer.print(File.new("ruby_prof_output.txt", "w"), 0)
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