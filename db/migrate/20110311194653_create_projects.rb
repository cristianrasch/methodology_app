class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.text :description     
      t.date :estimated_start_date
      t.date :estimated_end_date
      t.date :started_on
      t.date :ended_on
      t.integer :estimated_duration
      t.float :actual_duration

      t.timestamps
    end
    
    add_index :projects, [:started_on, :ended_on]
  end

  def self.down
    drop_table :projects
  end
end
