__ :name => "board"

squares {
  [0, 1, 2, 3, 4, 5, 6, 7, 8].each do |s|
    square :id => "square"+s.to_s
  end
}

options_box {
  prompt :id => "board_size", :text => "Select board dimensions:"
  option :id => "three", :text => "3 X 3", :text_color => "red"
  prompt
  option :id => "four", :text => "4 X 4"
  line_spacer
  prompt :id => "player_options", :text => "Select player options:"
  option :id => "pvc", :text => "Player vs Computer", :text_color => "red"
  prompt
  option :id => "pvp", :text => "Player vs Player"
  prompt
  option :id => "cvc", :text => "Computer vs Computer"
  line_spacer
  prompt :id => "choose_team", :text => "Select your team:"
  option :id => "x", :text => "X", :text_color => "red"
  prompt
  option :id => "o", :text => "O"
  line_spacer
  prompt :id => "difficulty_options", :text => "Select difficulty level:"
  option :id => "easy", :text => "Easy", :text_color => "red"
  prompt
  option :id => "med", :text => "Medium"
  prompt
  option :id => "hard", :text => "Hard"
}