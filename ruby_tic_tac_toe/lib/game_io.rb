class GameIO
end


class TextGameIO
  class << self
    def get_valid_input(prompt, possible_values)
      val = ""
    
      while true
        $stdout.puts prompt
        val = $stdin.gets.chomp
      
        if possible_values.call(val)
          break
        else
          $stdout.puts "Invalid input. Please try again."
        end
      end
    
      return val
    end
  
    def print_board(board)
      display_block = ""
    
      board.get_num_spaces.times do |location|
        if board.space_contents(location) == nil
          display_block += get_formatted_line_spacing(board, false, location+1) + (location+1).to_s
        else
          display_block += get_formatted_line_spacing(board, false, 0) + convert_space_val_to_graphic(board.space_contents(location))
        end
        if (location % board.get_size) == (board.get_size - 1)
          display_block += get_formatted_line_spacing(board, true, 0)
        end
      end
    
      puts display_block
    end

  
    private #----------------------------------------------------
  
    def get_formatted_line_spacing(board, is_end, location)
      return "|\n" if is_end == true
      return "| " if board.get_size > 3 && location < 10
      return "|"
    end
  
    def convert_space_val_to_graphic(team)
      if team == 1
        return "X"
      elsif team == 2
        return "O"
      else
        return " "
      end
    end
  end
end


class GUIGameIO
  def print_board(board)
    
  end
  
  def get_valid_input(prompt, possible_values)
    
  end
end