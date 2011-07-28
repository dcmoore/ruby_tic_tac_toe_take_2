class Board
  attr_reader :dim_rows, :dim_cols, :spaces

  def initialize(rows, cols)
    @dim_rows = rows
    @dim_cols = cols
    @spaces = Hash.new(EMPTY)
  end


  def reset
    @spaces.clear
  end


  def space_contents(location)
    return @spaces[location]
  end


  def make_move(location, team)
    if team == EMPTY
      @spaces.delete(location)
    else
      @spaces[location] = team
    end
  end
  
  
  def num_total_spaces
    return @dim_rows * @dim_cols
  end


  def draw_board
    display_block = ""
    
    num_total_spaces.times do |location|
      display_block += "|" + convert_space_val_to_graphic(@spaces[location])
      if (location % @dim_cols) == (@dim_cols - 1)
        display_block += "|\n"
      end
    end
    
    puts display_block
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


  def num_moves_made
    return @spaces.length
  end


  def is_board_full?
    if num_moves_made == (@dim_rows * @dim_cols)
      return true
    end

    return false
  end
end