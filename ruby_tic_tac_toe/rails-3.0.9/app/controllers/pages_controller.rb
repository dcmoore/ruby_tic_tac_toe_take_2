require File.expand_path(File.dirname(__FILE__) + '/../../../lib/rails_game_engine.rb')

class PagesController < ApplicationController
  def index
    @title = "Tic Tac Toe | Play Mode"
    @games = Game.all
    
    if params[:move] != nil && session[:current_game].board.space_contents(location) == nil && returns_false_if_game_isnt_over == false
      make_move(params[:move].to_i)
    end
    
    if returns_false_if_game_isnt_over == false && is_it_computers_turn? == true
  	  make_move(session[:current_game].get_ai_move)
    end
	
	  set_record_flag_if_game_over
  end

  def review
    reset_session_vars
    @title = "Tic Tac Toe | Review Mode"
    @games = Game.all
    
    if Game.find(params[:game]).moves.find(:all, :order => "location DESC").first.location > 8
      populate_board(4, params[:move].to_i)
    else
      populate_board(3, params[:move].to_i)
    end
  end
  
  def new_game
    reset_session_vars
        
    if params[:board_size] == nil
      session[:current_game] = RailsGameEngine.new(3, "rows_cols_diags", "pvc", "X", "Easy", "Easy")
    else
      session[:current_game] = RailsGameEngine.new(params[:board_size].to_i, params[:rules], params[:players], params[:team], params[:ai1], params[:ai2])
    end
    
    if session[:current_game].board.get_num_moves_made == 0 && params[:players] == "pvc" && params[:team] == "O"
      make_move(session[:current_game].get_ai_move)
    end
    
    if params[:players] == "cvc"
      while returns_false_if_game_isnt_over == false
        make_move(session[:current_game].get_ai_move)
      end
	  
	    set_record_flag_if_game_over
    end
    
    redirect_to '/index'
  end
  
  private #--------------------------------
  
  def reset_session_vars
    session[:current_game] = ""
    session[:recorded_game_yet] = "no"
    session[:moves] = []
    session[:team] = []
    @game_id = nil
  end
  
  def populate_board(size, max_move)
    session[:current_game] = RailsGameEngine.new(size, "rows_cols_diags", "pvc", "X", "Easy", "Easy")
    i = 0
    Game.find(params[:game]).moves.find(:all).each do |move|
      if i < max_move
        make_move(move.location)
        i = i + 1
      end
    end
  end
  
  def make_move(location)
    team = session[:current_game].current_team(session[:current_game].board)
    session[:current_game].board.make_move(location, team)
    session[:moves].push(location)
    session[:team].push(team)
  end
  
  def returns_false_if_game_isnt_over
    return session[:current_game].is_game_over?(session[:current_game].board, session[:current_game].rules)
  end
  
  def is_it_computers_turn?
    if session[:current_game].player1.class == TicTacToeComputerPlayer && session[:current_game].player1.team == 1
      return true if session[:current_game].current_team(session[:current_game].board) == 1
    elsif session[:current_game].player1.class == TicTacToeComputerPlayer && session[:current_game].player1.team == 2
      return true if session[:current_game].current_team(session[:current_game].board) == 2
    elsif session[:current_game].player2.class == TicTacToeComputerPlayer && session[:current_game].player2.team == 1
      return true if session[:current_game].current_team(session[:current_game].board) == 1
    elsif session[:current_game].player2.class == TicTacToeComputerPlayer && session[:current_game].player2.team == 2
      return true if session[:current_game].current_team(session[:current_game].board) == 2
    end
    return false
  end
  
  def set_record_flag_if_game_over
  	if returns_false_if_game_isnt_over != false && session[:recorded_game_yet] != "done"
  		record_game_if_flag_set
  	end
  end
  
  def record_game_if_flag_set
    game = Game.create(:outcome => get_outcome_text)
    session[:moves].length.times do |i|
      Move.create(:game_id => game.id, :location => session[:moves][i], :team => session[:team][i])
    end
	
    session[:recorded_game_yet] = "done"
    @game_id = game.id
  end
  
  def get_outcome_text
    return "X Won" if returns_false_if_game_isnt_over == 1
	  return "O Won" if returns_false_if_game_isnt_over == 2
	  return "Draw" if returns_false_if_game_isnt_over == 5
  end
end
