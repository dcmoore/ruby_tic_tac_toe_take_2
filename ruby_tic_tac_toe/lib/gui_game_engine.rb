$: << File.dirname(__FILE__)
require 'tic_tac_toe_board'
require 'human_player'
require 'computer_player'
require 'constants'
require 'game_io'
require 'save_load_object'


class GUIGameEngine < GameEngine
  attr_reader :board, :rules, :player_val, :team_val
  
  def initialize(scene)
    @scene = scene
    get_settings
  end
  
  def get_settings
    create_and_set_board
    set_rules
    create_and_set_players
  end
  
  def get_ai_move
    if @player1.class == TicTacToeComputerPlayer && current_team(@board) == @player1.team
      return get_player_move(@player1)
    elsif @player2.class == TicTacToeComputerPlayer && current_team(@board) == @player2.team
      return get_player_move(@player2)
    end
  end
  
  def get_player_move(plyr)
    ai_move = -1
    
    if @difficulty == "Easy"
      ai_move = plyr.easy_difficulty(board)
    elsif @difficulty == "Medium"
      ai_move = plyr.medium_difficulty(board)
    else
      ai_move = plyr.hard_difficulty(board)
    end
    
    return ai_move
  end
  
  
  private #------------------------------------------
  
  def create_and_set_board
    board_val = @scene.find("opt_board").value
    if board_val == "3X3"
      @board = TicTacToeBoard.new(3)
    else
      @board = TicTacToeBoard.new(4)
    end
  end
  
  def set_rules
    rules_val = @scene.find("opt_rules").value
    if rules_val == "Standard"
      @rules = "rows_cols_diags"
    else
      @rules = "rows_cols_diags_blocks"
    end
  end
  
  def create_and_set_players
    @player_val = @scene.find("opt_player").value
    @difficulty = @scene.find("opt_difficulty").value
    @team_val = @scene.find("opt_team").value
    selected_team = 999
    
    if @player_val == "Player vs Player"
      @player1 = TextHumanPlayer.new(X, "Human1")
      @player2 = TextHumanPlayer.new(O, "Human2")
    elsif @player_val == "Player vs AI"
      if @team_val == "X"
        selected_team = X
      else
        selected_team = O
      end
      
      @player1 = TextHumanPlayer.new(selected_team, "Human")
      @player2 = TicTacToeComputerPlayer.new(what_is_the_other_team(selected_team), "AIBot", @difficulty, @rules)
    else # AI vs AI
      @player1 = TicTacToeComputerPlayer.new(X, "AIBot1", @difficulty, @rules)
      @player2 = TicTacToeComputerPlayer.new(O, "AIBot2", @difficulty, @rules)
    end
  end
end