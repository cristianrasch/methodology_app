Factory.define :user do |u|
  u.username { ActiveSupport::SecureRandom.hex(3) }
  u.email {|uu| "#{uu.username}@consejo.org.ar"}
  u.name { |uu| "User ##{uu.username}" }
  u.password ActiveSupport::SecureRandom.hex(3)
  u.org_unit 'Turismo'
end

Factory.define :project do |p|
  p.description Faker::Lorem.paragraph
  p.requirement Faker::Lorem.paragraph
  p.estimated_start_date 2.months.ago.to_date
  p.estimated_end_date 3.months.from_now.to_date
  p.estimated_duration 80
  p.association :owner, :factory => :user
  p.association :dev, :factory => :user
  p.association :project_name
  3.times { p.after_build { |pp| pp.users << Factory(:user) } }
end

Factory.define :event do |e|
  e.stage Conf.stages.first.first
  e.status Conf.statuses.first.first
  e.duration 25
  e.association :project
  e.association :author, :factory => :user
end

Factory.define :comment do |c|
  c.content Faker::Lorem.paragraph
  c.association :commentable, :factory => :event
  c.association :author, :factory => :user
  c.after_build { |cc| cc.users << Factory(:user) }
end

Factory.define :task do |t|
  t.description Faker::Lorem.paragraph
  t.association :author, :factory => :user
  t.association :owner, :factory => :user
  t.association :project
end

Factory.define :project_name do |pn|
  pn.sequence(:text) {|n| "Project ##{n}"}
end

Factory.define :holiday do |h|
  h.sequence(:name) {|n| "Holiday ##{n}"}
  h.date Date.tomorrow
end
