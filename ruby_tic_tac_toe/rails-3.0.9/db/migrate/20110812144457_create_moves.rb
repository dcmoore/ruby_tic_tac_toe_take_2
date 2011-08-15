class CreateMoves < ActiveRecord::Migration
  def self.up
    create_table :moves do |t|
      t.integer :game_id
      t.integer :location
      t.integer :team

      t.timestamps
    end
  end

  def self.down
    drop_table :moves
  end
end
