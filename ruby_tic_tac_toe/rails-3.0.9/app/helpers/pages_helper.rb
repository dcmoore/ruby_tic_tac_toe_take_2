# Why doesn't this work, but load does?
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/rails_game_engine')

module PagesHelper
  def get_game
    if @current_game.class == RailsGameEngine
      puts "=============================="
      return @current_game
    end
    
    puts "-----------------------------"
    # return RailsGameEngine.new(3, "rows_cols_diags", "pvc", "X", "Easy", "Easy")
  end

  def print_board
    return "TODO - pages_helper"
    
    # html = "<table id='board'>"
    # html += "<tr>"
    # html += "<td>X</td>"
    # html += "<td>X</td>"
    # html += "<td></td>"
    # html += "</tr>"
    # html += "<tr>"
    # html += "<td></td>"
    # html += "<td>O</td>"
    # html += "<td></td>"
    # html += "</tr>"
    # html += "<tr>"
    # html += "<td></td>"
    # html += "<td></td>"
    # html += "<td></td>"
    # html += "</tr>"
    # html += "</table>"
    # return html
  end
  
  def get_square_html
    
  end
end
