module Board
  def scene_opened(event)
    production.game = GUIGameEngine.new(scene)
  end
end