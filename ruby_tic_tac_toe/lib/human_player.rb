require 'constants'

class HumanPlayer < Player
end

class TextHumanPlayer < HumanPlayer
  def take_turn(board)
    board.print_board_with_empty_locations
    $stdout.puts "Select location of next move:"
    move = $stdin.gets.chomp.to_i - 1
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