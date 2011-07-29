module Option
  def self.extended(prop)
    prop.three = prop.scene.find("three")
    prop.four = prop.scene.find("four")
    prop.pvc = prop.scene.find("pvc")
    prop.pvp = prop.scene.find("pvp")
    prop.cvc = prop.scene.find("cvc")
    prop.x = prop.scene.find("x")
    prop.o = prop.scene.find("o")
    prop.easy = prop.scene.find("easy")
    prop.med = prop.scene.find("med")
    prop.hard = prop.scene.find("hard")
  end
  
  attr_accessor :three, :four, :pvc, :pvp, :cvc, :x, :o, :easy, :med, :hard
  
  def mouse_clicked(e)
    if id == "three"
      three.style.text_color = "red"
      four.style.text_color = "black"
    elsif id == "four"
      three.style.text_color = "black"
      four.style.text_color = "red"
    end
    
    if id == "pvc"
      pvc.style.text_color = "red"
      pvp.style.text_color = "black"
      cvc.style.text_color = "black"
    elsif id == "pvp"
      pvc.style.text_color = "black"
      pvp.style.text_color = "red"
      cvc.style.text_color = "black"
    elsif id == "cvc"
      pvc.style.text_color = "black"
      pvp.style.text_color = "black"
      cvc.style.text_color = "red"
    end
    
    if id == "x"
      x.style.text_color = "red"
      o.style.text_color = "black"
    elsif id == "o"
      x.style.text_color = "black"
      o.style.text_color = "red"
    end
    
    if id == "easy"
      easy.style.text_color = "red"
      med.style.text_color = "black"
      hard.style.text_color = "black"
    elsif id == "med"
      easy.style.text_color = "black"
      med.style.text_color = "red"
      hard.style.text_color = "black"
    elsif id == "hard"
      easy.style.text_color = "black"
      med.style.text_color = "black"
      hard.style.text_color = "red"
    end
  end
end