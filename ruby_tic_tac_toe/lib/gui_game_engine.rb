$: << File.dirname(__FILE__)
require 'tic_tac_toe_board'
require 'human_player'
require 'computer_player'
require 'constants'
require 'game_io'
require 'save_load_object'


class GUIGameEngine < GameEngine
  attr_reader :board, :rules
  
  def initialize(scene)
    @scene = scene
    get_settings
    run_game
  end
  
  def get_settings
    create_and_set_board
    set_rules
    create_and_set_players
  end
  
  def run_game
    puts "------------------------------"
    #####################
  end
  
  
  private #------------------------------------------
  
  def create_and_set_board
    board_val = @scene.find("opt_board")
    if board_val.value == "3X3"
      @board = TicTacToeBoard.new(3)
    else
      @board = TicTacToeBoard.new(4)
    end
    
    puts "Board: " + @board.get_size.to_s
  end
  
  def set_rules
    rules_val = @scene.find("opt_rules")
    if rules_val.value == "Standard"
      @rules = "rows_cols_diags"
    else
      @rules = "rows_cols_diags_blocks"
    end
    
    puts "Rules: " + @rules.to_s
  end
  
  def create_and_set_players
    player_val = @scene.find("opt_player")
    @difficulty = @scene.find("opt_difficulty")
    team_val = @scene.find("opt_team")
    selected_team = 999
    
    if player_val.value == "Player vs Player"
      @player1 = TextHumanPlayer.new(X, "Human1")
      @player2 = TextHumanPlayer.new(O, "Human2")
    elsif player_val.value == "Player vs AI"
      if team_val == "X"
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
    
    puts "Player 1: " + @player1.name.to_s
    puts "Player 2: " + @player2.name.to_s
  end
end