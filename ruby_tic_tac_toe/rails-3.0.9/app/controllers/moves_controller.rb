class MovesController < ApplicationController
  def index
    @moves = Move.all
  end

  def show
    @move = Move.find(params[:id])
  end

  def new
    @move = Move.new
  end

  def edit
    @move = Move.find(params[:id])
  end

  def create
    @move = Move.new(params[:move])
  end

  def update
    @move = Move.find(params[:id])
  end

  def destroy
    @move = Move.find(params[:id])
    @move.destroy
  end
end
