class PagesController < ApplicationController
  def index
    @games = Game.all
  end

  def review
    @games = Game.all
  end
end
