module Square  
  def mouse_clicked(e)
    fill_space_action(id, "X")
  end
  
  def fill_space_action(id, team)
    square = scene.find(id)
    square.text = team
  end
end