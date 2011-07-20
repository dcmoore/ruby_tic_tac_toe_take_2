require 'constants'

class Space
  attr_reader :row, :col
  attr_accessor :val

  def initialize(r, c, v)
    @row = r
    @col = c
    @val = v
  end
end