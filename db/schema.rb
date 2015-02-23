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

ActiveRecord::Schema.define(version: 20150222230905) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "links", force: :cascade do |t|
    t.integer  "term_id"
    t.integer  "linked_term_id"
    t.integer  "link_on_term_counter"
    t.integer  "term_on_link_counter"
    t.integer  "weight"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "links", ["linked_term_id"], name: "index_links_on_linked_term_id", using: :btree
  add_index "links", ["term_id"], name: "index_links_on_term_id", using: :btree

  create_table "terms", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "language"
    t.text     "markup"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
