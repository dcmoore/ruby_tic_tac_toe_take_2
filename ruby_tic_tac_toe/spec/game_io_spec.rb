require File.dirname(__FILE__) + "/spec_helper"
require 'game_io'
require 'tic_tac_toe_board'

describe GameIO do
  before do
    @original_stdin, @original_stdout = $stdin, $stdout
    @myio_in, @myio_out = StringIO.new, StringIO.new
    $stdout = @myio_out
  end
  
  after do
    $stdin.close ; $stdout.close
    $stdin, $stdout = @original_stdin, @original_stdout
  end
  
  it "TextGameIO.get_valid_input - gets valid input from stdin" do
    prompt = "Test to see if this works"
    possible_values = lambda{|x| x == "1" || x == "2" || x == "3" || x == "4"}
    @myio_in.string = "5\n4\n"
    $stdin = @myio_in
    TextGameIO.get_valid_input(prompt, possible_values).should == "4"
    @myio_out.string.should == "Test to see if this works\nInvalid input. Please try again.\nTest to see if this works\n"
  end
  
  it "TextGameIO.get_valid_input - testing to see about regexs" do
    prompt = "Test to see if this works"
    possible_values = lambda{|x| x[/^[A-Za-z0-9]+$/]}
    @myio_in.string = "invalid!\nvalid\n"
    $stdin = @myio_in
    TextGameIO.get_valid_input(prompt, possible_values).should == "valid"
    @myio_out.string.should == "Test to see if this works\nInvalid input. Please try again.\nTest to see if this works\n"
  end
  
  it "TextGameIO.new.print_board - prints the board to stdout" do
    board = TicTacToeBoard.new(3)
    board.make_move(5, X)
    TextGameIO.print_board(board)
    @myio_out.string.should == "|1|2|3|\n|4|5|X|\n|7|8|9|\n"
  end
end