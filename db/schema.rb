# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141218154420) do

  create_table "api_keys", force: true do |t|
    t.string   "access_token"
    t.integer  "user_id"
    t.datetime "expire_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "columns", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.integer  "task_id"
    t.integer  "user_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["task_id"], name: "index_comments_on_task_id"

  create_table "days_progresses", force: true do |t|
    t.date    "date"
    t.float   "expected"
    t.float   "real"
    t.integer "project_id"
  end

  add_index "days_progresses", ["project_id"], name: "index_days_progresses_on_project_id"

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "locks", force: true do |t|
    t.integer  "locker_id"
    t.integer  "locked_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "performance_progresses", force: true do |t|
    t.date     "date"
    t.integer  "expected"
    t.integer  "real"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "performance_progresses", ["project_id"], name: "index_performance_progresses_on_project_id"

  create_table "project_users", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_users", ["project_id"], name: "index_project_users_on_project_id"
  add_index "project_users", ["user_id"], name: "index_project_users_on_user_id"

  create_table "projects", force: true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "man_hours"
    t.float    "cost",                default: 0.0
    t.string   "xml_file"
    t.integer  "work_hours"
    t.boolean  "resources",           default: false
    t.boolean  "report"
    t.string   "type_resources"
    t.decimal  "progress",            default: 0.0
    t.datetime "expected_start_date"
    t.datetime "expected_end_date"
  end

  create_table "pushes", force: true do |t|
    t.string   "mail"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", force: true do |t|
    t.integer  "task_id"
    t.decimal  "progress"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.float    "resources",  default: 0.0
  end

  add_index "reports", ["created_at"], name: "index_reports_on_created_at"
  add_index "reports", ["task_id"], name: "index_reports_on_task_id"

  create_table "resources_progresses", force: true do |t|
    t.date     "date"
    t.float    "expected"
    t.float    "real"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resources_progresses", ["project_id"], name: "index_resources_progresses_on_project_id"

  create_table "resources_reports", force: true do |t|
    t.integer  "task_id"
    t.decimal  "resources"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "task_positions", force: true do |t|
    t.integer  "column_id"
    t.integer  "task_id"
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_positions", ["column_id"], name: "index_task_positions_on_column_id"
  add_index "task_positions", ["project_id"], name: "index_task_positions_on_project_id"
  add_index "task_positions", ["task_id"], name: "index_task_positions_on_task_id"
  add_index "task_positions", ["user_id"], name: "index_task_positions_on_user_id"

  create_table "tasks", force: true do |t|
    t.string   "name"
    t.datetime "expected_start_date"
    t.datetime "expected_end_date"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "parent_id"
    t.integer  "level"
    t.decimal  "man_hours",           default: 0.0
    t.decimal  "progress",            default: 0.0
    t.string   "description"
    t.boolean  "deleted"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "children_count",      default: 0,   null: false
    t.integer  "reports_count",       default: 0,   null: false
    t.float    "duration"
    t.integer  "mpp_uid"
    t.decimal  "resources",           default: 0.0
    t.float    "resources_cost",      default: 0.0
    t.boolean  "urgent"
  end

  add_index "tasks", ["parent_id"], name: "index_tasks_on_parent_id"
  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id"
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "role"
    t.integer  "api_key_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

end
