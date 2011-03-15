#Factory.define :user do |u|
#  u.sequence(:email) {|n| "user#{n}@gmail.com"}
#  u.password 'pass123'
#  u.password_confirmation {|a| a.password}
#end

Factory.define :user do |u|
  u.username Faker::Name.first_name[0,3]
  u.email Faker::Internet.email
  u.name Faker::Name.name
  u.password ActiveSupport::SecureRandom.hex(3)
  u.org_unit 'sistemas'
end

Factory.define :project do |p|
  p.org_unit 'Sistemas'
  p.area 'Desarrollo'
  p.sequence(:first_name) {|n| "Project ##{n}"}
  p.description Faker::Lorem.paragraph
  p.estimated_start_date 1.week.ago.to_date
  p.estimated_end_date 3.months.from_now.to_date
  p.estimated_duration 80
end
