# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110511161454) do

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.string   "attachment"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["author_id"], :name => "index_comments_on_author_id"

  create_table "comments_users", :id => false, :force => true do |t|
    t.integer "comment_id"
    t.integer "user_id"
  end

  add_index "comments_users", ["comment_id", "user_id"], :name => "index_comments_users_on_comment_id_and_user_id"
  add_index "comments_users", ["user_id"], :name => "index_comments_users_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "events", :force => true do |t|
    t.integer  "stage"
    t.integer  "status"
    t.string   "attachment1"
    t.string   "attachment2"
    t.string   "attachment3"
    t.integer  "duration"
    t.integer  "project_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "duration_unit", :limit => 1, :default => 1
  end

  add_index "events", ["author_id"], :name => "index_events_on_author_id"
  add_index "events", ["project_id"], :name => "index_events_on_project_id"

  create_table "holidays", :force => true do |t|
    t.string   "name"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "holidays", ["date"], :name => "index_holidays_on_date", :unique => true

  create_table "project_names", :force => true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.integer  "ancestry_depth", :default => 0
  end

  add_index "project_names", ["ancestry"], :name => "index_project_names_on_ancestry"
  add_index "project_names", ["text"], :name => "index_project_names_on_text", :unique => true

  create_table "projects", :force => true do |t|
    t.text     "description"
    t.date     "estimated_start_date"
    t.date     "estimated_end_date"
    t.date     "started_on"
    t.date     "ended_on"
    t.integer  "estimated_duration"
    t.float    "actual_duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dev_id"
    t.integer  "owner_id"
    t.integer  "status",                  :limit => 1, :default => 1
    t.integer  "updated_by"
    t.integer  "compl_perc",              :limit => 1, :default => 0
    t.integer  "klass",                   :limit => 1, :default => 1
    t.date     "envisaged_end_date"
    t.integer  "estimated_duration_unit", :limit => 1, :default => 1
    t.integer  "project_name_id"
  end

  add_index "projects", ["dev_id"], :name => "index_projects_on_dev_id"
  add_index "projects", ["owner_id"], :name => "index_projects_on_owner_id"
  add_index "projects", ["project_name_id"], :name => "index_projects_on_project_name_id"
  add_index "projects", ["started_on", "ended_on"], :name => "index_projects_on_started_on_and_ended_on"
  add_index "projects", ["status"], :name => "index_projects_on_status"
  add_index "projects", ["updated_by"], :name => "index_projects_on_updated_by"

  create_table "projects_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "project_id"
  end

  add_index "projects_users", ["project_id"], :name => "index_projects_users_on_project_id"
  add_index "projects_users", ["user_id", "project_id"], :name => "index_projects_users_on_user_id_and_project_id"

  create_table "tasks", :force => true do |t|
    t.text     "description"
    t.string   "attachment1"
    t.string   "attachment2"
    t.string   "attachment3"
    t.integer  "author_id"
    t.integer  "owner_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "finished_at"
    t.integer  "duration"
    t.integer  "status",        :limit => 1, :default => 1
    t.integer  "updated_by"
    t.integer  "duration_unit", :limit => 1, :default => 1
  end

  add_index "tasks", ["author_id"], :name => "index_tasks_on_author_id"
  add_index "tasks", ["owner_id"], :name => "index_tasks_on_owner_id"
  add_index "tasks", ["project_id"], :name => "index_tasks_on_project_id"
  add_index "tasks", ["status"], :name => "index_tasks_on_status"
  add_index "tasks", ["updated_by"], :name => "index_tasks_on_updated_by"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "name"
    t.string   "org_unit"
    t.string   "email"
    t.string   "encrypted_password",   :limit => 128
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
