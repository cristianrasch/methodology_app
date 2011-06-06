class CreateOrgUnits < ActiveRecord::Migration
  def self.up
    create_table :org_units do |t|
      t.string :text
      t.integer :parent_id
      
      t.timestamps
    end
    add_index :org_units, [:parent_id, :text]
  end

  def self.down
    drop_table :org_units
  end
end
