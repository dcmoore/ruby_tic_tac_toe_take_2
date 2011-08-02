Board
  -reset - clears all previous moves from the game board
  -space_contents(location) - returns the contents of the specified space
  -dim_rows - returns the number of rows in the board
  -dim_cols - returns the number of columns in the board
  -num_moves_made - returns the number of moves that have been made on the board
  -num_total_spaces - returns the number of total spaces that the board contains
  -print_board - exports the board in it's current state to $stdout.puts
  -print_board_with_empty_locations - does everything print_board does and shows locations instead of empty spaces
Player
  -team - returns the player's team number
  HumanPlayer
    TextHumanPlayer
      -take_turn - returns a board with an additional move specified by a human player through standard input
    GUIHumanPlayer
      -take_turn - returns a board with an additional move specified by a human player through a Limelight GUI
  ComputerPlayer
    -take_turn(Board, difficulty) - returns a board with the best move taken (based off of the set difficulty)
    TextComputerPlayer
    GUIComputerPlayer
Calculate
  -self.what_is_the_other_team(team) - returns the team that just moved
  -self.is_game_over?(Board, rules) - returns 1 if x won, 2 if o won, 5 if it is a draw, and false if none of that
  -self.current_team(Board) - returns the team who is next in line to make a move