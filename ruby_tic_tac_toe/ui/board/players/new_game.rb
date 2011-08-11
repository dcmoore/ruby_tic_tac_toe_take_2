module NewGame  
  def mouse_clicked(e)
    production.game = GUIGameEngine.new(scene)
    
    opt = scene.find("opt_board")
    if opt.value == "3X3"
      reset_board([0,1,2,3,4,5,6,7,8])
      
      squares = scene.find_by_name("square")
      squares.each do |s|
        s.style.width = 100
        s.style.height = 100
        s.style.font_size = 60
        s.style.background_color = "white"
      end
    elsif opt.value == "4X4"
      reset_board([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15])
      
      squares = scene.find_by_name("square")
      squares.each do |s|
        s.style.width = 75
        s.style.height = 75
        s.style.font_size = 50
      end
    end
    
    if production.game.player_val == "AI vs AI"
      while production.game.is_game_over?(production.game.board, production.game.rules) == false
        make_ai_move
      end
      
      change_squares_color("red")
    elsif production.game.player_val == "Player vs AI" && production.game.team_val == "O"
      make_ai_move
    end
  end
  
  private #--------------------------
  
  def make_ai_move
    change_squares_color("yellow")
    
    ai_move = scene.find(production.game.get_ai_move)
    fill_space_action(ai_move, production.game.current_team(production.game.board))
    production.game.board.make_move(ai_move.id.to_i, production.game.current_team(production.game.board))
    
    change_squares_color("white")
  end
  
  def change_squares_color(color)
    squares = scene.find_by_name("square")
    squares.each do |s|
      s.style.background_color = color
    end
  end
  
  def reset_board(space_id_list)
    container = scene.find("squares_container")
    container.remove_all
    container.build do
      space_id_list.each do |i|
        square :id => i.to_s
      end
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