$: << File.dirname(__FILE__)
require 'tic_tac_toe_board'
require 'human_player'
require 'computer_player'
require 'constants'
require 'game_io'
require 'save_load_object'


class RailsGameEngine < GameEngine
  attr_reader :board, :rules, :player1, :player2
  
  def initialize(b_size, r, p, team, diff1, diff2)
    @board = TicTacToeBoard.new(b_size)
    @rules = r
    create_and_set_players(p, team, diff1, diff2)
  end
  
  def get_ai_move    
  end
  
  def get_player_move(plyr)    
  end
  
  #private --------------------------------------------
  
  def create_and_set_players(p, team, diff1, diff2)
    if p == "pvc"
      if team == "X"
        @player1 = TextHumanPlayer.new(X, "Human")
        @player2 = TicTacToeComputerPlayer.new(O, "AIBot", diff1, @rules)
      else
        @player1 = TicTacToeComputerPlayer.new(X, "AIBot", diff1, @rules)
        @player2 = TextHumanPlayer.new(O, "Human")
      end
    elsif p == "pvp"
      @player1 = TextHumanPlayer.new(X, "Human1")
      @player2 = TextHumanPlayer.new(O, "Human2")
    elsif p == "cvc"
      @player1 = TicTacToeComputerPlayer.new(X, "AIBot1", diff1, @rules)
      @player2 = TicTacToeComputerPlayer.new(O, "AIBot2", diff2, @rules)
    else
      raise "Invalid player type: #{p} <#{__FILE__}:#{__LINE__}>"
    end
  end
end