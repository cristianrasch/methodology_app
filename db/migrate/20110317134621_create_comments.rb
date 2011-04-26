class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :content
      t.integer :commentable_id
      t.string :commentable_type
      t.string :attachment
      
      t.integer :author_id

      t.timestamps
    end
    
    add_index :comments, :author_id
  end

  def self.down
    drop_table :comments
  end
end
