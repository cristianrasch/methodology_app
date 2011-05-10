class CreateProjectNames < ActiveRecord::Migration
  def self.up
    create_table :project_names do |t|
      t.string :text
      t.timestamps
    end
    add_index :project_names, :text, :unique => true 
  end

  def self.down
    remove_index :project_names, :text
    drop_table :project_names
  end
end
