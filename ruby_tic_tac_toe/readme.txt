Board
  make_move(location, team) - updates the game board to reflect a move by the specified team
  reset - clears all previous moves from the game board
  space_contents(location) - returns the contents of the specified space
  dim_rows - returns the number of rows in the board
  dim_cols - returns the number of columns in the board
  num_moves_made - returns the number of moves that have been made on the board
  spaces - returns the hash representing the current state of the board
  num_total_spaces - returns the number of total spaces that the board contains
  draw_board - exports the board in it's current state to $stdout.puts
  convert_space_val_to_graphic(team) - returns the graphic value given to the team
  is_board_full? - returns true if all spaces have been filled with moves and false otherwise
Player
  type - returns the type of player (Human or Computer)
Calculate
  self.what_is_the_other_team(team) - returns the team that just moved
  self.is_game_over?(Board) - returns 1 if x won, 2 if o won, 5 if it is a draw, and false if none of that
  self.current_team(Board) - returns the team who is next in line to make a move
  self.best_move(Board, difficulty) - returns an int representing the hash key of the best possible move left on the board