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

ActiveRecord::Schema.define(version: 20130419055252) do

  create_table "discuss_users", force: true do |t|
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "discuss_users", ["user_id", "user_type"], name: "index_discuss_users_on_user_id_and_user_type"

  create_table "message_users", force: true do |t|
    t.integer  "message_id"
    t.integer  "discuss_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_users", ["discuss_user_id"], name: "index_message_users_on_discuss_user_id"
  add_index "message_users", ["message_id"], name: "index_message_users_on_message_id"

  create_table "messages", force: true do |t|
    t.string   "subject"
    t.text     "body"
    t.integer  "discuss_user_id"
    t.integer  "parent_id"
    t.boolean  "draft",           default: false
    t.boolean  "trashed",         default: false
    t.boolean  "deleted",         default: false
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["discuss_user_id"], name: "index_messages_on_discuss_user_id"

end
