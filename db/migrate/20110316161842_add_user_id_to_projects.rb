class AddUserIdToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :owner_id, :integer
    add_index :projects, :owner_id
  end

  def self.down
    remove_index :projects, :owner_id
    remove_column :projects, :owner_id
  end
end
