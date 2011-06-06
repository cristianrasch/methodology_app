class CreateDocuments < ActiveRecord::Migration
  module Duration
    DAY = 2
  end
  
  def self.up
    create_table :documents do |t|
      t.string :file
      t.integer :duration
      t.integer :duration_unit, :default => Duration::DAY, :limit => 1
      t.string :comment
      t.integer :event_id

      t.timestamps
    end
    
    add_index :documents, :event_id
  end

  def self.down
    drop_table :documents
  end
end
