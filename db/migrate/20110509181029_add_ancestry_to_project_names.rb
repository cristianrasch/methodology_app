class AddAncestryToProjectNames < ActiveRecord::Migration
  def self.up
    add_column :project_names, :ancestry, :string
    add_index :project_names, :ancestry
    add_column :project_names, :ancestry_depth, :integer, :default => 0
  end

  def self.down
    remove_column :project_names, :ancestry_depth
    remove_index :project_names, :ancestry
    remove_column :project_names, :ancestry
  end
end
