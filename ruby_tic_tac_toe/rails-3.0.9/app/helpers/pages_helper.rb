require File.expand_path(File.dirname(__FILE__) + '/../lib/gui_game_engine')

module PagesHelper
  def print_board
    html = "<table id='board'>"
    "<tr>"
    "<td>X</td>"
    "<td>X</td>"
    "<td></td>"
    "</tr>"
    "<tr>"
    "<td></td>"
    "<td>O</td>"
    "<td></td>"
    "</tr>"
    "<tr>"
    "<td></td>"
    "<td></td>"
    "<td></td>"
    "</tr>"
    "</table>"
    return html
  end
  
  def get_square_html
    
  end
end
