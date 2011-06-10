class RemoveDelayedByFromProjects < ActiveRecord::Migration
  def self.up
    remove_index :projects, :delayed_by
    remove_column :projects, :delayed_by
  end

  def self.down
    add_column :projects, :delayed_by, :integer
    add_index :projects, :delayed_by
  end
end
