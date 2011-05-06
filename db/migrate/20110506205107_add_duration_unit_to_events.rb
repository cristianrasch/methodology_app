class AddDurationUnitToEvents < ActiveRecord::Migration
  module Duration
    HOUR = 1
  end
  
  def self.up
    add_column :events, :duration_unit, :integer, :default => Duration::HOUR, :limit => 1
  end

  def self.down
    remove_column :events, :duration_unit
  end
end
