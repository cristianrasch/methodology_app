class AddStatusUpdatedByToProjects < ActiveRecord::Migration
  class Project
    class Status
      NEW = 1
    end
  end

  def self.up
    add_column :projects, :status, :integer, :default => Project::Status::NEW, :limit => 1
    add_index :projects, :status
    add_column :projects, :updated_by, :integer
    add_index :projects, :updated_by
  end

  def self.down
    remove_index :projects, :updated_by
    remove_column :projects, :updated_by
    remove_index :projects, :status
    remove_column :projects, :status
  end
end
