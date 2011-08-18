class Move < ActiveRecord::Base
  validates :game_id, :presence => true, :numericality => true
  validates :location, :presence => true, :numericality => true
  validates :team, :presence => true, :numericality => true
  belongs_to :game
end
