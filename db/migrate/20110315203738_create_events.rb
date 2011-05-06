class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :stage
      t.integer :status
      
      1.upto(3) { |i| t.string "attachment#{i}" }
      
      t.float :duration
      
      t.references :project
      t.integer :author_id

      t.timestamps
    end
    
    add_index :events, :author_id
    add_index :events, :project_id
  end

  def self.down
    drop_table :events
  end
end
