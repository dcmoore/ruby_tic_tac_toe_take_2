module Square  
  def mouse_clicked(e)
    square = scene.find(id)
    if is_space_empty?(square) == true
      if production.game.is_game_over?(production.game.board, production.game.rules) == false
        puts "game aint ova yet"
        fill_space_action(square, production.game.current_team(production.game.board))
      end
    end
  end
  
  def is_space_empty?(square)
    if square.text == ""
      return true
    end
    
    return false
  end
  
  def fill_space_action(square, team)
    if team == 1
      square.text = "X"
    elsif team == 2
      square.text = "O"
    end
  end
end