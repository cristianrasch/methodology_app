class RemoveAttrsFromEvents < ActiveRecord::Migration
  def self.up
    change_table(:events) do |t|
      1.upto(3) { |i| t.remove "attachment#{i}" }
      t.remove :duration
      t.remove :duration_unit
    end
  end

  def self.down
    change_table(:events) do |t|
      t.integer :duration_unit
      t.integer :duration
      1.upto(3) { |i| t.string "attachment#{i}" }
    end
  end
end
