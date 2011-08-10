module Square  
  def mouse_clicked(e)
    square = scene.find(id)
    
    puts "Board size: " + production.game.board.get_size.to_s
    puts "Rules: " + production.game.rules.to_s
    puts "Players: " + production.game.player_val.to_s
    puts "Human Team: " + production.game.team_val.to_s
    
    if is_space_empty?(square) == true
      if production.game.player_val == "Player vs Player"
        make_move_if_game_isnt_over_yet(square, id)
      elsif production.game.player_val == "Player vs AI"
        if production.game.team_val == "X"
          if production.game.current_team(production.game.board) == 1
            make_move_if_game_isnt_over_yet(square, id)
          end
        elsif production.game.team_val == "O"
          if production.game.current_team(production.game.board) == 2
            make_move_if_game_isnt_over_yet(square, id)
          end
        end
      end
    end
  end
  
  def is_space_empty?(square)
    if square.text == ""
      return true
    end
    
    return false
  end
  
  def make_move_if_game_isnt_over_yet (square, id)
    if production.game.is_game_over?(production.game.board, production.game.rules) == false
      fill_space_action(square, production.game.current_team(production.game.board))
      production.game.board.make_move(id.to_i, production.game.current_team(production.game.board))
    end
  end
  
  def fill_space_action(square, team)
    if team == 1
      square.text = "X"
    elsif team == 2
      square.text = "O"
    end
  end
end