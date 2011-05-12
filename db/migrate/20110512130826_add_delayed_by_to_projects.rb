class AddDelayedByToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :delayed_by, :integer
    add_index :projects, :delayed_by
  end

  def self.down
    remove_index :projects, :delayed_by
    remove_column :projects, :delayed_by
  end
end
