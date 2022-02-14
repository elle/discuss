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

ActiveRecord::Schema.define(version: 20130428235128) do

  create_table "discuss_messages", force: true do |t|
    t.string   "subject"
    t.text     "body"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "ancestry"
    t.text     "draft_recipient_ids"
    t.datetime "sent_at"
    t.datetime "received_at"
    t.datetime "read_at"
    t.datetime "trashed_at"
    t.datetime "deleted_at"
    t.boolean  "editable",            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "discuss_messages", ["ancestry"], name: "index_discuss_messages_on_ancestry"
  add_index "discuss_messages", ["user_type", "user_id"], name: "index_discuss_messages_on_user_type_and_user_id"

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
