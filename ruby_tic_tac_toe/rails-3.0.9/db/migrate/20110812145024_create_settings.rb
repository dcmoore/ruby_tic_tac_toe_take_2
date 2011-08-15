class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.integer :game_id
      t.integer :rules
      t.integer :players
      t.integer :team
      t.integer :difficulty
      t.integer :board_size

      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
