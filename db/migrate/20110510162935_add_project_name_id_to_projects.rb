class AddProjectNameIdToProjects < ActiveRecord::Migration
  def self.up
    change_table(:projects) do |t|
      t.references :project_name
    end
    
    add_index(:projects, :project_name_id)
  end

  def self.down
    remove_index(:projects, :project_name_id)
    
    change_table(:projects) do |t|
      t.remove :project_name_id
    end
  end
end
