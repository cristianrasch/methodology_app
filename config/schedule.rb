# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "log/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every :sunday, :at => '12pm' do
  runner 'User.notify_devs_who_have_not_signed_in_since_last_week'
end

every :sunday, :at => '2pm' do
  runner 'Project.notify_devs_compl_perc_has_not_been_updated_since_last_week'
end
