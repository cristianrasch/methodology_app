class AddReqNbrToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :req_nbr, :integer
    add_index :projects, :req_nbr
  end

  def self.down
    remove_index :projects, :req_nbr
    remove_column :projects, :req_nbr
  end
end
