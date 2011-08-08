class TicTacToeBoard
  def initialize(s)
    @size = s
    @spaces = Hash.new(EMPTY)
  end
  
  def get_size
    @size
  end
  
  def get_num_spaces
    return @size * @size
  end
  
  def get_num_moves_made
    return @spaces.length
  end
  
  def make_move(location, team)
    if team == EMPTY
      @spaces.delete(location)
    else
      @spaces[location] = team
    end
  end

  def space_contents(location)
    return @spaces[location]
  end
  
  def reset
    @spaces.clear
  end
end