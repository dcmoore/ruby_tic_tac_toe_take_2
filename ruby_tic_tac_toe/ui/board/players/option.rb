module Option
  def value_changed(e)
    button = scene.find_by_name("new_game")
    button.each do |b|
      # Is there no way to do this? Looked at the source code and can't find a way
      # b.style.text_color = "red"
    end
  end
end