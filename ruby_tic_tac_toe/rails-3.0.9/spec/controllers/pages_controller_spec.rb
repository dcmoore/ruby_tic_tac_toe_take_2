require 'spec_helper'

describe PagesController do
  render_views
  
  def get_game
    session[:current_game]
  end
  
  def get_board
    session[:current_game].board
  end
  
  def get_p1
    session[:current_game].player1
  end
  
  def get_p2
    session[:current_game].player2
  end
    
  describe "GET 'index'" do
    before(:each) do
  	  post :new_game, :board_size => "3", :rules => "rows_cols_diags", :players => "pvp", :team => "X", :ai1 => "Easy", :ai2 => "Easy"
    end
  
    it "should be successful" do
      get 'index'
      response.should be_success
      response.should have_selector("title", :content => "Play")
    end
  
    it "should make the appropriate move when a square is clicked" do
      post :index, :move => 4
      get_board.space_contents(4).should == 1
    end

    it "should not allow moves to be made if the space is full" do
      post :index, :move => 4
      post :index, :move => 4
      get_board.get_num_moves_made.should == 1
    end
  
    it "should not allow moves to be made if the game is over" do
      make_5_moves
      post :index, :move => 6
      post :index, :move => 7
      get_board.get_num_moves_made.should == 5
    end
	
  	it "should log moves as the game is going" do
  	  post :index, :move => 0
      post :index, :move => 4
  	  post :index, :move => 1
  	  session[:moves][0].should == 0
  	  session[:team][0].should == 1
  	  session[:moves][1].should == 4
  	  session[:team][1].should == 2
  	  session[:moves][2].should == 1
  	  session[:team][2].should == 1
  	end
	
  	it "should dump the session vars recording the game moves into a database on game over only once per game" do
  	  make_5_moves

  	  assigns[:game_id].should_not == nil
	    game = Game.find(assigns[:game_id])
	    
  	  game.outcome.should == "X Won"
  	  game.moves.length.should == 5
  	  
  	  game.moves.each do |m|
  	    m.game_id.should == game.id
  	  end
  	end
  	
  	def make_5_moves
  	  post :index, :move => 0
      post :index, :move => 4
      post :index, :move => 1
      post :index, :move => 5
      post :index, :move => 2
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
      post :new_game, :board_size => "4", :rules => "rows_cols_diags_blocks", :players => "cvc", :team => "O", :ai1 => "Easy", :ai2 => "Easy"
      get_board.get_size.should == 4
      get_game.rules.should == "rows_cols_diags_blocks"
      get_p1.team.should == 1
      get_p1.class.should == TicTacToeComputerPlayer
      get_p1.get_difficulty.should == "Easy"
      get_p2.team.should == 2
      get_p2.class.should == TicTacToeComputerPlayer
      get_p2.get_difficulty.should == "Easy"
    end
    
    it "should make the first move if the settings have a computer player up first" do
      post :new_game, :board_size => "3", :rules => "rows_cols_diags_blocks", :players => "pvc", :team => "O", :ai1 => "Easy", :ai2 => "Easy"
      get_board.get_num_moves_made.should == 1
    end
    
    it "the computer should make moves when and where it is supposed to" do
      post :new_game, :board_size => "3", :rules => "rows_cols_diags", :players => "pvc", :team => "X", :ai1 => "Hard", :ai2 => "Easy"
      post :index, :move => 0
      get_board.space_contents(4).should == 2
      post :index, :move => 1
      get_board.space_contents(2).should == 2
      get_board.get_num_moves_made.should == 4
    end
    
    it "the computer should play out a full game if the settings are AI vs AI" do
      post :new_game, :board_size => "3", :rules => "rows_cols_diags", :players => "cvc", :team => "X", :ai1 => "Easy", :ai2 => "Easy"
      get_game.is_game_over?(get_board, get_game.rules).should_not == false
    end
  end
end
