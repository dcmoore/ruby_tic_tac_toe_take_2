require File.dirname(__FILE__) + "/spec_helper"
require 'computer_player'
require 'human_player'

describe Player do
  it "team - returns the team of the player (Human or Computer)" do
    player1 = ComputerPlayer.new(X, "Robot Steve", "Hard", "rows_cols_diags")
    player1.team.should == X
    player1.name.should == "Robot Steve"
    player2 = HumanPlayer.new(O, "Dave")
    player2.team.should == O
    player2.name.should == "Dave"
  end
end