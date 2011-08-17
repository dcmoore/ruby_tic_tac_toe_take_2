load(File.expand_path(File.dirname(__FILE__) + '/../../../lib/rails_game_engine.rb'))

class PagesController < ApplicationController
  def index
    @games = Game.all
    @title = "Tic Tac Toe | Play Mode"
  end

  def review
    @games = Game.all
    @title = "Tic Tac Toe | Review Mode"
  end
  
  def new_game
    if params[:board_size] == nil
      @current_game = RailsGameEngine.new(3, "rows_cols_diags", "pvc", "X", "Easy", "Easy")
    else
      @current_game = RailsGameEngine.new(params[:board_size].to_i, params[:rules], params[:players], params[:team], params[:ai1], params[:ai2])
    end
    
    redirect_to '/index'
  end
end
