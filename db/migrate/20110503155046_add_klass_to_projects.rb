class AddKlassToProjects < ActiveRecord::Migration
  class Project
    class Klass
      DEV = 1
    end
  end

  def self.up
    add_column :projects, :klass, :integer, :limit => 1, :default => Project::Klass::DEV
  end

  def self.down
    remove_column :projects, :klass
  end
end
