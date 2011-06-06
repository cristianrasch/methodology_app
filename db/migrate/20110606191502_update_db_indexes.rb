class UpdateDbIndexes < ActiveRecord::Migration
  def self.up
    remove_index :projects, [:started_on, :ended_on]
    add_index :projects, :started_on
    add_index :projects, [:estimated_start_date, :estimated_end_date]
    add_index :comments, [:commentable_id, :commentable_type]
    add_index :tasks, :finished_at
    add_index :projects, [:estimated_start_date, :envisaged_end_date]
    remove_index :project_names, [:ancestry, :text]
    add_index :project_names, [:text, :ancestry]
    remove_index :org_units, [:parent_id, :text]
    add_index :org_units, [:text, :parent_id]
    remove_index :projects, :req_nbr
  end

  def self.down
    add_index :projects, :req_nbr
    remove_index :org_units, [:text, :parent_id]
    add_index :org_units, [:parent_id, :text]
    remove_index :project_names, [:text, :ancestry]
    add_index :project_names, [:ancestry, :text]
    remove_index :projects, [:estimated_start_date, :envisaged_end_date]
    remove_index :tasks, :finished_at
    remove_index :comments, [:commentable_id, :commentable_type]
    remove_index :projects, [:estimated_start_date, :estimated_end_date]
    remove_index :projects, :started_on
    add_index :projects, [:started_on, :ended_on]
  end
end
