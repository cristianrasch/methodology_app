class AddUpdatedByToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :updated_by, :integer
    add_index :tasks, :updated_by
  end

  def self.down
    remove_index :tasks, :updated_by
    remove_column :tasks, :updated_by
  end
end
