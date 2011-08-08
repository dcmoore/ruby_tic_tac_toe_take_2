class SaveLoadObject
  class << self
    def file_exists?(file_name)
      return File.exist?("temp/" + file_name + "_save_game.txt")
    end
    
    def load(file_name)
      loaded_board = nil
      File.open("temp/" + file_name + "_save_game.txt","rb") {|file| loaded_board = Marshal.load(file)}
      File.delete("temp/" + file_name + "_save_game.txt")
      return loaded_board
    end
    
    def save(file_name, obj)
      File.open("temp/" + file_name + "_save_game.txt","wb") {|file| Marshal.dump(obj,file)}
    end
  end
end