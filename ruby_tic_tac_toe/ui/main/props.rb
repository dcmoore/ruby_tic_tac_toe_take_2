__ :name => "board"

squares :id => "squares_container" do
  [0, 1, 2, 3, 4, 5, 6, 7, 8].each do |s|
    square :id => s.to_s
  end
end

options_box do
  prompt :id => "board_size", :text => "Select board dimensions:"
  option :id => "opt_board", :players => "combo_box", :choices => ["3X3", "4X4"]
  line_spacer
  prompt :id => "rules", :text => "Select rules:"
  option :id => "opt_rules", :players => "combo_box", :choices => ["Standard", "2X2 Block Win"]
  line_spacer
  prompt :id => "player_options", :text => "Select player options:"
  option :id => "opt_player", :players => "combo_box", :choices => ["Player vs AI", "Player vs Player", "AI vs AI"]
  line_spacer
  prompt :id => "difficulty", :text => "Select difficulty level:"
  option :id => "opt_difficulty", :players => "combo_box", :choices => ["Easy", "Medium", "Hard"]
  line_spacer
  prompt :id => "choose_team", :text => "Select your team:"
  option :id => "opt_team", :players => "combo_box", :choices => ["X", "O"]
  line_spacer
  line_spacer
  button_spacer
  new_game :players => 'button', :text => 'New Game'
end