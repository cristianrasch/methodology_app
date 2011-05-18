class CreateProjectNames < ActiveRecord::Migration
  def self.up
    create_table :project_names do |t|
      t.string :text
      t.timestamps
    end
  end

  def self.down
    drop_table :project_names
  end
end
