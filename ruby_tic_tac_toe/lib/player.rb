class Player
  attr_reader :team, :name

  def initialize(t, n)
    @team = t
    @name = n
  end
end