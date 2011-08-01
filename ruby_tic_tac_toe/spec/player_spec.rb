require File.dirname(__FILE__) + "/spec_helper"
require 'player'

describe Player do
  it "team - returns the team of the player (Human or Computer)" do
    player1 = ComputerPlayer.new(X)
    player1.team.should == X
    player2 = HumanPlayer.new(O)
    player2.team.should == O
  end
end