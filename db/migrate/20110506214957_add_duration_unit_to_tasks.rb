class AddDurationUnitToTasks < ActiveRecord::Migration
  module Duration
    DAY = 2
  end
  
  def self.up
    add_column :tasks, :duration_unit, :integer, :default => Duration::DAY, :limit => 1
  end

  def self.down
    remove_column :tasks, :duration_unit
  end
end
