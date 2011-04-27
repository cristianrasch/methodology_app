class AddStatusToTasks < ActiveRecord::Migration
  class Task
    class Status
      NEW = 1
    end
  end

  def self.up
    add_column :tasks, :status, :integer, :default => Task::Status::NEW, :limit => 1
    add_index :tasks, :status
  end

  def self.down
    remove_index :tasks, :status
    remove_column :tasks, :status
  end
end
