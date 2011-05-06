class AddEnvisagedEndDateToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :envisaged_end_date, :date
  end

  def self.down
    remove_column :projects, :envisaged_end_date
  end
end
