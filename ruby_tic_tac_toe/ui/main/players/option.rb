module Option
  def value_changed(e)
    if id == "opt_board"
      opt = scene.find(id)
      if opt.value == "3X3"
        reset_board([0,1,2,3,4,5,6,7,8])
        
        squares = scene.find_by_name("square")
        squares.each do |s|
          s.style.width = 100
          s.style.height = 100
          s.style.font_size = 60
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
    end
  end
  
  def reset_board(space_id_list)
    container = scene.find("squares_container")
    container.remove_all
    container.build do
      space_id_list.each do |i|
        square :id => "square"+i.to_s
      end
    end
  end
end