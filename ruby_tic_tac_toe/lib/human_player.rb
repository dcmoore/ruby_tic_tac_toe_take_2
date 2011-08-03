require 'constants'

class HumanPlayer < Player
end

class TextHumanPlayer < HumanPlayer
  def take_turn(board)
    $stdout.puts "Select location of next move (or enter 'S' to save board and exit game):"
    move = $stdin.gets.chomp
    
    return "EXIT" if save_and_exit?(move, board) == true
    move = move.to_i - 1
    move = validate_move(board, move)
  
    if board.space_contents(move) == EMPTY
      board.make_move(move, team)
      $stdout.puts "Move successfully made"
    else
      $stdout.puts "Cannot move to a space that is already full"
    end
    
    return board
  end
  
  
  private #------------------------------------------
  
  def save_and_exit?(move, board)
    if move == "S" || move == "s" || move == "save" || move == "SAVE" || move == "Save"
      file_name = get_file_name
      File.open("temp/" + file_name + "_save_game.txt","wb") {|file| Marshal.dump(board,file)}
      
      return true
    end
    return false
  end
  
  def get_file_name
    file_name = ""
    
    while !(valid_file_name(file_name) == true && File.exist?("temp/" + file_name + "_save_game.txt") == false)
      $stdout.puts "Enter the name you wish to save your game under:"
      file_name = $stdin.gets.chomp
    end
    
    return file_name
  end
  
  def valid_file_name(file_name)
    if file_name == "" || file_name == "test"
      return false
    end
    return true
  end
  
  def validate_move(board, move)
    while !(move.to_i >= 0 && move.to_i < board.num_total_spaces)
      board.print_board_with_empty_locations
      $stdout.puts "Invalid Move. Please select another move:"
      move = $stdin.gets.chomp.to_i - 1
    end

    return move
  end
end

class GUIHumanPlayer < HumanPlayer
  def take_turn(board)
    
  end
end