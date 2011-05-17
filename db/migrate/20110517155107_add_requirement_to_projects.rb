class AddRequirementToProjects < ActiveRecord::Migration
  def self.up
    change_table :projects do |t|
      t.string :requirement
    end
  end

  def self.down
    change_table :projects do |t|
      t.remove :requirement
    end
  end
end
