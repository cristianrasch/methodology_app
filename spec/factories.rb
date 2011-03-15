Factory.define :user do |u|
  u.username { rand(10).to_s+rand(10).to_s+rand(10).to_s }
  u.sequence(:email) {|n| "user#{n}@consejo.org.ar"}
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
  p.association :dev, :factory => :user
end
