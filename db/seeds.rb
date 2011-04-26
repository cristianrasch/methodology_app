# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# import production users
User.import
User.find_by_username('gar').update_attribute(:position, User::Position::MANAGER)
User.find_by_username('mev').update_attribute(:position, User::Position::BOSS)

# create random projects
3.times do |i|
  project = Factory(:project, :started_on => i.days.ago.to_date)
  # add some events to those projects
  2.times { Factory(:event, :status => i+1, :project => project) }
  # add some comments to those events
  project.events.each { |event| Factory(:comment, :commentable => event) }
end
