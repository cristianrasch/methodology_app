class CreateHolidays < ActiveRecord::Migration
  def self.up
    create_table :holidays do |t|
      t.string :name
      t.date :date

      t.timestamps
    end
    add_index(:holidays, :date, :unique => true)
  end

  def self.down
    remove_index(:holidays, :date)
    drop_table :holidays
  end
end
