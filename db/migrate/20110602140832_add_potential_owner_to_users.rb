class AddPotentialOwnerToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :potential_owner, :boolean, :default => false
  end

  def self.down
    remove_column :users, :potential_owner
  end
end
