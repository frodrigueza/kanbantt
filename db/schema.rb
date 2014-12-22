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

ActiveRecord::Schema.define(version: 20141222163719) do

  create_table "api_keys", force: true do |t|
    t.string   "access_token"
    t.integer  "user_id"
    t.datetime "expire_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignments", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["project_id"], name: "index_assignments_on_project_id"
  add_index "assignments", ["user_id"], name: "index_assignments_on_user_id"

  create_table "comments", force: true do |t|
    t.integer  "task_id"
    t.integer  "project_id"
    t.integer  "enterprise_id"
    t.integer  "user_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["project_id"], name: "index_comments_on_project_id"
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

  create_table "enterprises", force: true do |t|
    t.text     "name"
    t.integer  "boss_id"
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

  create_table "projects", force: true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "expected_start_date"
    t.datetime "expected_end_date"
    t.decimal  "progress",            default: 0.0
    t.integer  "resources_type",      default: 0
    t.decimal  "resources",           default: 0.0
    t.decimal  "resources_cost",      default: 0.0
    t.decimal  "cost"
    t.string   "xml_file"
    t.boolean  "resources_reporting", default: false
    t.integer  "enterprise_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pushes", force: true do |t|
    t.string   "mail"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", force: true do |t|
    t.decimal  "progress"
    t.float    "resources"
    t.integer  "task_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reports", ["task_id"], name: "index_reports_on_task_id"
  add_index "reports", ["user_id"], name: "index_reports_on_user_id"

  create_table "resources_progresses", force: true do |t|
    t.date     "date"
    t.float    "expected"
    t.float    "real"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resources_progresses", ["project_id"], name: "index_resources_progresses_on_project_id"

  create_table "tasks", force: true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "expected_start_date"
    t.datetime "expected_end_date"
    t.integer  "level"
    t.decimal  "progress",            default: 0.0
    t.text     "description"
    t.boolean  "deleted"
    t.boolean  "urgent"
    t.decimal  "resources",           default: 0.0
    t.decimal  "resources_cost",      default: 0.0
    t.decimal  "duration",            default: 0.0
    t.integer  "map_uid"
    t.integer  "parent_id"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mpp_uid"
  end

  add_index "tasks", ["parent_id"], name: "index_tasks_on_parent_id"
  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id"
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "enterprise_id"
    t.string   "name"
    t.string   "last_name"
    t.boolean  "super_admin",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
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
