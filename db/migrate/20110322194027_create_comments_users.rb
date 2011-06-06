class CreateCommentsUsers < ActiveRecord::Migration
  def self.up
    create_table :comments_users, :id => false do |t|
      t.references :comment
      t.references :user
    end
    
    add_index :comments_users, [:comment_id, :user_id]
    add_index :comments_users, :user_id
  end

  def self.down
    drop_table :comments_users
  end
end
