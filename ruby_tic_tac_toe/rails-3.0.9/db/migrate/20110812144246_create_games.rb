class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.datetime :timestamp
      t.string :outcome

      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end