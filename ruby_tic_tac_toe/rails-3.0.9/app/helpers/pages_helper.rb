module PagesHelper
  def print_board(board)
    html = "<div id='board_con'>"
    if board.get_size == 3
      html += "<table id='board_3'>"
    else
      html += "<table id='board_4'>"
    end
    
    board.get_num_spaces.times do |location|
      if (location % board.get_size) == (board.get_size)
        html += "<tr>"
      end
      
      if board.space_contents(location) == nil
        html += "<td id='" + location.to_s + "'></td>"
      else
        html += "<td id='" + location.to_s + "'>" + get_square_val(board.space_contents(location)) + "</td>"
      end
      
      if (location % board.get_size) == (board.get_size - 1)
        html += "</tr>"
      end
    end
    
    return html + "</table></div>"
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
  
  def print_settings_comments
	html = "<!--***"
	
	html += session[:current_game].board.get_size.to_s + ","
	html += session[:current_game].rules.to_s + ","
	
	if session[:current_game].player1.class == TicTacToeComputerPlayer && session[:current_game].player2.class == TicTacToeComputerPlayer
		html += "cvc,"
		html += "X,"
		html += session[:current_game].player1.get_difficulty.to_s + ","
		html += session[:current_game].player2.get_difficulty.to_s
	elsif session[:current_game].player1.class == TicTacToeComputerPlayer
		html += "pvc,"
		html += "O,"
		html += session[:current_game].player1.get_difficulty.to_s + ","
		html += "Easy"
	elsif session[:current_game].player2.class == TicTacToeComputerPlayer
		html += "pvc,"
		html += "X,"
		html += session[:current_game].player2.get_difficulty.to_s + ","
		html += "Easy"
	else
		html += "pvp,"
		html += "X,"
		html += "Easy,"
		html += "Easy"
	end
	
	return html + "***-->"
  end
end
