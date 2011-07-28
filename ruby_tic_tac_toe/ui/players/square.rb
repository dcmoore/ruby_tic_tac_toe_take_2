module Square
  def self.extended(prop)
    prop.square0 = prop.scene.find("square0")
    prop.square1 = prop.scene.find("square1")
    prop.square2 = prop.scene.find("square2")
    prop.square3 = prop.scene.find("square3")
    prop.square4 = prop.scene.find("square4")
    prop.square5 = prop.scene.find("square5")
    prop.square6 = prop.scene.find("square6")
    prop.square7 = prop.scene.find("square7")
    prop.square8 = prop.scene.find("square8")
  end
  
  attr_accessor :square0, :square1, :square2, :square3, :square4, :square5, :square6, :square7, :square8
  
  def mouse_clicked(e)
    if id == "square0"
      square0.text = "X"
    elsif id == "square1"
      square1.text = "X"
    elsif id == "square2"
      square2.text = "X"
    elsif id == "square3"
      square3.text = "X"
    elsif id == "square4"
      square4.text = "X"
    elsif id == "square5"
      square5.text = "X"
    elsif id == "square6"
      square6.text = "X"
    elsif id == "square7"
      square7.text = "X"
    elsif id == "square8"
      square8.text = "X"
    end
  end
end