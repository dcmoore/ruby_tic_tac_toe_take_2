require 'spec_helper'

describe PagesController do
  render_views
  
  describe "GET 'index'" do
    it "should be successful" do
      match 'index'
      response.should be_success
    end
  end
  
  describe "GET 'review'" do
    it "should be successful" do
      match 'review'
      response.should be_success
    end
  end
  
  describe "POST or GET 'new_game'" do
    it "should be successful" do
      match 'new_game'
      response.should be_success
    end
    
    it "sets options of new game based on params" do
      post :new_game, :board_size => "4", :rules => "rows_cols_diags_blocks", :players => "cvc", :team => "O", :ai1 => "Hard", :ai2 => "Hard"
      session[:current_game].board.get_size.should == 4
      session[:current_game].rules.should == "rows_cols_diags_blocks"
      session[:current_game].player1.team.should == 1
      session[:current_game].player1.class.should == TicTacToeComputerPlayer
      session[:current_game].player2.team.should == 2
      session[:current_game].player2.class.should == TicTacToeComputerPlayer
    end
  end
end
