module Square  
  def mouse_clicked(e)
    square = scene.find(id)
    
    if is_space_empty?(square) == true
      if is_it_humans_turn? == true
        make_move_if_game_isnt_over_yet(square, id)
      end
            
      squares = scene.find_by_name("square")
      squares.each do |s|
        s.style.background_color = "yellow"
      end
      
      if production.game.is_game_over?(production.game.board, production.game.rules) == false
        if production.game.player_val == "Player vs AI"
          ai_move = scene.find(production.game.get_ai_move)
          fill_space_action(ai_move, production.game.current_team(production.game.board))
          production.game.board.make_move(ai_move.id.to_i, production.game.current_team(production.game.board))
        end
      end
            
      squares = scene.find_by_name("square")
      squares.each do |s|
        s.style.background_color = "white"
      end
      
      if production.game.is_game_over?(production.game.board, production.game.rules) != false
        squares = scene.find_by_name("square")
        squares.each do |s|
          s.style.background_color = "red"
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
  
  def is_it_humans_turn?
    return true if production.game.player_val == "Player vs Player"
    
    if production.game.player_val == "Player vs AI"
      if production.game.team_val == "X"
        return true if production.game.current_team(production.game.board) == 1
      elsif production.game.team_val == "O"
        return true if production.game.current_team(production.game.board) == 2
      end
    end
    
    return false
  end
  
  def make_move_if_game_isnt_over_yet(square, id)
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