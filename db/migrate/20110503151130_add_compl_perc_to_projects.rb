class AddComplPercToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :compl_perc, :integer, :limit => 1, :default => 0
  end

  def self.down
    remove_column :projects, :compl_perc
  end
end
