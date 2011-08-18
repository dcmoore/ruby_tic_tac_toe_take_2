require File.expand_path(File.dirname(__FILE__) + '/../../../lib/rails_game_engine.rb')

class PagesController < ApplicationController
  def index
    @title = "Tic Tac Toe | Play Mode"
    @games = Game.all
    
    if params[:move] != nil
      make_move(params[:move].to_i)
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
    
    if session[:current_game].board.get_num_moves_made == 0 && (params[:players] == "cvc" || (params[:players] == "pvc" && params[:team] == "O"))
      session[:current_game].board.make_move(session[:current_game].get_ai_move, 1)
    end
    
    redirect_to '/index'
  end
  
  private #--------------------------------
  
  def make_move(location)
    if session[:current_game].board.space_contents(location) == nil && session[:current_game].is_game_over?(session[:current_game].board, session[:current_game].rules) == false
      session[:current_game].board.make_move(location, session[:current_game].current_team(session[:current_game].board))
    end
  end
end
