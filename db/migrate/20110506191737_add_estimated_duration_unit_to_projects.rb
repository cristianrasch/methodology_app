class AddEstimatedDurationUnitToProjects < ActiveRecord::Migration
  module Duration
    DAY = 2
  end
  
  def self.up
    add_column :projects, :estimated_duration_unit, :integer, :default => Duration::DAY, :limit => 1
  end

  def self.down
    remove_column :projects, :estimated_duration_unit
  end
end
