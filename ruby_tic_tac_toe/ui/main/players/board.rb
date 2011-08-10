module Board
  def scene_opened(event)
    puts "---------New Game Created---------"
    production.game = GUIGameEngine.new(scene)
  end
end