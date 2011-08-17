module PagesHelper
  def print_board(board)
    if board.get_size == 3
      html = "<table id='board_3'>"
    else
      html = "<table id='board_4'>"
    end
    
    board.get_num_spaces.times do |location|
      if (location % board.get_size) == (board.get_size)
        html += "<tr>"
      end
      
      if board.space_contents(location) == nil
        html += "<td id='" + location.to_s + "'></td>"
      else
        html += "<td id='" + location.to_s + "'>" + board.space_contents(location) + "</td>"
      end
      
      if (location % board.get_size) == (board.get_size - 1)
        html += "</tr>"
      end
    end
    
    return html + "</table>"
  end
  
  def get_square_val(team)
    if team == 1
      return "X"
    elsif team == 2
      return "O"
    else
      return " "
    end
  end
end
