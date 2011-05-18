class AddOrgUnitIdToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :org_unit_id, :integer
    add_index :projects, :org_unit_id
  end

  def self.down
    remove_index :projects, :org_unit_id
    remove_column :projects, :org_unit_id
  end
end
