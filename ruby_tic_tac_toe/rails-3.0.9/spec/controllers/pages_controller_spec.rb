require 'spec_helper'

describe PagesController do
  render_views
    
  describe "GET 'index'" do
    before(:each) do
      session[:current_game] = RailsGameEngine.new(3, "rows_cols_diags", "pvp", "X", "Easy", "Easy")
    end
  
    it "should be successful" do
      get 'index'
      response.should be_success
      response.should have_selector("title", :content => "Play")
    end
  
    it "should make the appropriate move when a square is clicked" do
      post :index, :move => 4
      session[:current_game].board.space_contents(4).should == 1
    end

    it "should not allow moves to be made if the space is full" do
      post :index, :move => 4
      post :index, :move => 4
      session[:current_game].board.get_num_moves_made.should == 1
    end
  
    it "should not allow moves to be made if the game is over" do
      post :index, :move => 0
      post :index, :move => 4
      post :index, :move => 1
      post :index, :move => 5
      post :index, :move => 2
      post :index, :move => 6
      post :index, :move => 7
      session[:current_game].board.get_num_moves_made.should == 5
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
      session[:current_game].player1.get_difficulty.should == "Hard"
      session[:current_game].player2.team.should == 2
      session[:current_game].player2.class.should == TicTacToeComputerPlayer
      session[:current_game].player2.get_difficulty.should == "Hard"
    end
    
    it "should make the first move if the settings have a computer player up first" do
      post :new_game, :board_size => "3", :rules => "rows_cols_diags", :players => "pvc", :team => "O", :ai1 => "Easy", :ai2 => "Easy"
      session[:current_game].board.get_num_moves_made.should == 1
    end
  end
end
