class AddLastComplPercUpdateAtToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :last_compl_perc_update_at, :datetime
  end

  def self.down
    remove_column :projects, :last_compl_perc_update_at
  end
end
