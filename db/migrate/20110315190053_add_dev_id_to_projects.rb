class AddDevIdToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :dev_id, :integer
    add_index :projects, :dev_id
  end

  def self.down
    remove_index :projects, :dev_id
    remove_column :projects, :dev_id
  end
end
