namespace :db do
  desc "Drops, creates and populates the current database"
  task :recreate => ['migrate:reset', 'seed'] do
    p 'done.'
  end
end
