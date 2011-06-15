class AddTrackableToUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      t.trackable
    end
  end

  def self.down
    change_table(:users) do |t|
      t.remove :sign_in_count
      t.remove :current_sign_in_at
      t.remove :last_sign_in_at
      t.remove :current_sign_in_ip
      t.remove :last_sign_in_ip
    end
  end
end
