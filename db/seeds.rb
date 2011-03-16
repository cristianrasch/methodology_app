# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

#User.import
crr = User.find_by_username('crr')
3.times {|i|
  project = Factory(:project, :dev_id => crr.id, :owner_id => crr.id,
                    :started_on => i.days.ago.to_date)
}
