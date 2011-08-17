require File.expand_path(File.dirname(__FILE__) + '/../../../lib/rails_game_engine.rb')

class PagesController < ApplicationController
  def index
    @title = "Tic Tac Toe | Play Mode"
    @games = Game.all
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
    
    redirect_to '/index'
  end
end
