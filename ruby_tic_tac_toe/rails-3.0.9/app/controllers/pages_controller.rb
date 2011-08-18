require File.expand_path(File.dirname(__FILE__) + '/../../../lib/rails_game_engine.rb')

class PagesController < ApplicationController
  def index
    @title = "Tic Tac Toe | Play Mode"
    @games = Game.all
    
    if params[:move] != nil
      make_move(params[:move].to_i)
    end
    
    if returns_false_if_game_isnt_over == false && is_it_computers_turn? == true
      session[:current_game].board.make_move(session[:current_game].get_ai_move, session[:current_game].current_team(session[:current_game].board))
    end
  end

  def review
    @title = "Tic Tac Toe | Review Mode"
    @games = Game.all
  end
  
  def new_game
    session[:current_game] = ""
        
    if params[:board_size] == nil
      session[:current_game] = RailsGameEngine.new(3, "rows_cols_diags", "pvc", "X", "Easy", "Easy")
    else
      session[:current_game] = RailsGameEngine.new(params[:board_size].to_i, params[:rules], params[:players], params[:team], params[:ai1], params[:ai2])
    end
    
    if session[:current_game].board.get_num_moves_made == 0 && params[:players] == "pvc" && params[:team] == "O"
      session[:current_game].board.make_move(session[:current_game].get_ai_move, 1)
    end
    
    if params[:players] == "cvc"
      while returns_false_if_game_isnt_over == false
        session[:current_game].board.make_move(session[:current_game].get_ai_move, session[:current_game].current_team(session[:current_game].board))
      end
    end
    
    redirect_to '/index'
  end
  
  private #--------------------------------
  
  def make_move(location)
    if session[:current_game].board.space_contents(location) == nil && returns_false_if_game_isnt_over == false
      session[:current_game].board.make_move(location, session[:current_game].current_team(session[:current_game].board))
    end
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
end
