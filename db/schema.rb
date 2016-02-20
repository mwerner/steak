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

ActiveRecord::Schema.define(version: 20160222025922) do

  create_table "events", force: :cascade do |t|
    t.string   "key",                             null: false
    t.string   "name"
    t.string   "body"
    t.string   "location"
    t.string   "image_url"
    t.string   "notes",      default: "--- []\n"
    t.datetime "occurs_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "events", ["key"], name: "index_events_on_key", unique: true

  create_table "grams", force: :cascade do |t|
    t.string "word1",                         null: false
    t.string "word2",                         null: false
    t.string "word3",                         null: false
    t.string "suffixes", default: "--- []\n", null: false
  end

  add_index "grams", ["word1", "word2", "word3"], name: "index_grams_on_words", unique: true

  create_table "rsvps", force: :cascade do |t|
    t.integer  "event_id",   null: false
    t.string   "username"
    t.boolean  "attending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "rsvps", ["event_id"], name: "index_rsvps_on_event_id", using: :btree

end
