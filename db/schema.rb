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

ActiveRecord::Schema.define(version: 20170130014636) do

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "email_reminders", force: :cascade do |t|
    t.string   "chronic"
    t.datetime "send_at"
    t.string   "title"
    t.text     "description"
    t.integer  "notice_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["notice_id"], name: "index_email_reminders_on_notice_id"
  end

  create_table "notices", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.string   "notify_chronic"
    t.boolean  "repeat"
    t.datetime "notify_at"
    t.datetime "scheduled_at"
    t.datetime "sent_at"
    t.datetime "cancelled"
    t.binary   "inst"
    t.string   "meth"
    t.binary   "args"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags_todos", id: false, force: :cascade do |t|
    t.integer "todo_id", null: false
    t.integer "tag_id",  null: false
    t.index ["tag_id", "todo_id"], name: "index_tags_todos_on_tag_id_and_todo_id"
    t.index ["todo_id", "tag_id"], name: "index_tags_todos_on_todo_id_and_tag_id"
  end

  create_table "todos", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "title"
    t.text     "description"
    t.string   "show_at_chronic"
    t.integer  "show_at"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.integer  "lock_version"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "user_id"
    t.float    "priority"
    t.index ["category_id"], name: "index_todos_on_category_id"
    t.index ["user_id"], name: "index_todos_on_user_id"
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
