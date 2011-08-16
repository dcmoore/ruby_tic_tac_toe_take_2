$: << File.dirname(__FILE__)
require 'tic_tac_toe_board'
require 'human_player'
require 'computer_player'
require 'constants'
require 'game_io'
require 'save_load_object'


class GUIGameEngine < GameEngine
  def initialize(b_size, r, p, team, diff1, diff2)
    @board = Board.new(b_size)
    @rules = r
    @player1 = create_player1(p, team, diff1)
    @player2 = create_player2(p, team, diff1, diff2)
  end
  
  def get_ai_move    
  end
  
  def get_player_move(plyr)    
  end
  
  #private --------------------------------------------
  
  def create_player1(p, team, diff1)
    
  end
  
  def create_player2(p, team, diff1, diff2)
    
  end
end