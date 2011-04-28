class AddPositionToUsers < ActiveRecord::Migration
  class User
    class Position
      OTHER = 3
    end
  end

  def self.up
    add_column :users, :position, :integer, :default => User::Position::OTHER, :limit => 1
    add_index :users, :position
  end

  def self.down
    remove_index :users, :position
    remove_column :users, :position
  end
end
