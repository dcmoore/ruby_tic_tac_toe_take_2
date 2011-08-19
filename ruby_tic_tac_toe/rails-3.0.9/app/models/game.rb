class Game < ActiveRecord::Base
  validates :outcome, :presence => true
  validates_inclusion_of :outcome, :in => ["X Won", "O Won", "Draw"],
    :message => "%{value} is not a valid size"
  has_many :moves
end
