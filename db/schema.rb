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

ActiveRecord::Schema.define(:version => 20110615180443) do

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
  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"

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

  create_table "documents", :force => true do |t|
    t.string   "file"
    t.integer  "duration"
    t.integer  "duration_unit", :limit => 1, :default => 2
    t.string   "comment"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["event_id"], :name => "index_documents_on_event_id"

  create_table "events", :force => true do |t|
    t.integer  "stage"
    t.integer  "status"
    t.integer  "project_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "org_units", :force => true do |t|
    t.string   "text"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "org_units", ["text", "parent_id"], :name => "index_org_units_on_text_and_parent_id"

  create_table "project_names", :force => true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.integer  "ancestry_depth", :default => 0
  end

  add_index "project_names", ["text", "ancestry"], :name => "index_project_names_on_text_and_ancestry"

  create_table "projects", :force => true do |t|
    t.text     "description"
    t.date     "estimated_start_date"
    t.date     "estimated_end_date"
    t.date     "started_on"
    t.date     "ended_on"
    t.integer  "estimated_duration"
    t.integer  "actual_duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dev_id"
    t.integer  "owner_id"
    t.integer  "status",                  :limit => 1, :default => 1
    t.integer  "updated_by"
    t.integer  "compl_perc",              :limit => 1, :default => 0
    t.integer  "klass",                   :limit => 1, :default => 1
    t.date     "envisaged_end_date"
    t.integer  "estimated_duration_unit", :limit => 1, :default => 2
    t.integer  "project_name_id"
    t.string   "requirement"
    t.integer  "org_unit_id"
    t.integer  "req_nbr"
  end

  add_index "projects", ["dev_id"], :name => "index_projects_on_dev_id"
  add_index "projects", ["estimated_start_date", "envisaged_end_date"], :name => "index_projects_on_estimated_start_date_and_envisaged_end_date"
  add_index "projects", ["estimated_start_date", "estimated_end_date"], :name => "index_projects_on_estimated_start_date_and_estimated_end_date"
  add_index "projects", ["org_unit_id"], :name => "index_projects_on_org_unit_id"
  add_index "projects", ["owner_id"], :name => "index_projects_on_owner_id"
  add_index "projects", ["project_name_id"], :name => "index_projects_on_project_name_id"
  add_index "projects", ["started_on"], :name => "index_projects_on_started_on"
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
    t.integer  "duration_unit", :limit => 1, :default => 2
  end

  add_index "tasks", ["author_id"], :name => "index_tasks_on_author_id"
  add_index "tasks", ["finished_at"], :name => "index_tasks_on_finished_at"
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
    t.boolean  "potential_owner",                     :default => false
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
