class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.text :description

      1.upto(3) { |i| t.string "attachment#{i}" }
      
      t.integer :author_id
      t.integer :owner_id
      t.references :project
      
      t.timestamps
    end
    
    add_index :tasks, :author_id
    add_index :tasks, :owner_id
    add_index :tasks, :project_id
  end

  def self.down
    drop_table :tasks
  end
end
