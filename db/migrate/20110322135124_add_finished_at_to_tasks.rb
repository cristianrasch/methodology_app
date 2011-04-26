class AddFinishedAtToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :finished_at, :datetime
  end

  def self.down
    remove_column :tasks, :finished_at
  end
end
