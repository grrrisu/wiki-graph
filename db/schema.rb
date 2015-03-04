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

ActiveRecord::Schema.define(version: 20150304202328) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_terms", force: :cascade do |t|
    t.integer "category_id"
    t.integer "term_id"
  end

  add_index "categories_terms", ["category_id"], name: "index_categories_terms_on_category_id", using: :btree
  add_index "categories_terms", ["term_id"], name: "index_categories_terms_on_term_id", using: :btree

  create_table "links", force: :cascade do |t|
    t.integer  "term_id"
    t.integer  "linked_term_id"
    t.integer  "linked_term_counter"
    t.integer  "linking_term_counter"
    t.integer  "weight"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "links", ["linked_term_id"], name: "index_links_on_linked_term_id", using: :btree
  add_index "links", ["term_id"], name: "index_links_on_term_id", using: :btree

  create_table "parent_categories", force: :cascade do |t|
    t.integer  "parent_id"
    t.integer  "child_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "parent_categories", ["child_id"], name: "index_parent_categories_on_child_id", using: :btree
  add_index "parent_categories", ["parent_id"], name: "index_parent_categories_on_parent_id", using: :btree

  create_table "terms", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
