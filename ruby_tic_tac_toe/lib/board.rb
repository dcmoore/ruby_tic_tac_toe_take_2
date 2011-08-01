class Board
  attr_reader :dim_rows, :dim_cols

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
  
  def num_moves_made
    return @spaces.length
  end

  def print_board
    puts build_board_output(false)
  end
  
  def print_board_with_empty_locations
    puts build_board_output(true)
  end
  
  
  private #----------------------------------------------------
  
  def build_board_output(show_locations)
    display_block = ""
    
    num_total_spaces.times do |location|
      if show_locations == true && space_contents(location) == EMPTY
        display_block += "|" + (location+1).to_s
      else
        display_block += "|" + convert_space_val_to_graphic(@spaces[location])
      end
      if (location % @dim_cols) == (@dim_cols - 1)
        display_block += "|\n"
      end
    end
    
    return display_block
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