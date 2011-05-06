class AddDurationToTasks < ActiveRecord::Migration
  def self.up
    change_table :tasks  do |t|
      t.float :duration
    end
  end

  def self.down
    change_table :tasks  do |t|
      t.remove :duration
    end
  end
end
