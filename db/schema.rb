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

ActiveRecord::Schema.define(version: 20160615143004) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "departments", force: :cascade do |t|
    t.string   "name"
    t.integer  "university_id"
    t.text     "address"
    t.string   "site"
    t.string   "email"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "head_id"
    t.datetime "access_date"
    t.integer  "version"
    t.string   "info"
  end

  add_index "departments", ["head_id"], name: "index_departments_on_head_id", using: :btree
  add_index "departments", ["university_id"], name: "index_departments_on_university_id", using: :btree

  create_table "documents", force: :cascade do |t|
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "code"
    t.text     "fullname"
    t.integer  "university_id"
    t.datetime "date"
    t.text     "info"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "program_id"
    t.integer  "version"
    t.string   "file_ext"
  end

  add_index "documents", ["program_id"], name: "index_documents_on_program_id", using: :btree
  add_index "documents", ["university_id"], name: "index_documents_on_university_id", using: :btree

  create_table "founders", force: :cascade do |t|
    t.string   "director"
    t.string   "name"
    t.text     "address"
    t.string   "phone"
    t.string   "site"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.string   "degree"
    t.string   "rank"
    t.integer  "beginning_year"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.text     "upgrade"
    t.string   "middlename"
    t.string   "lastname"
    t.datetime "access_date"
    t.integer  "version"
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "person_id"
    t.string   "name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "placeable_id"
    t.string   "placeable_type"
    t.boolean  "is_manage"
  end

  add_index "posts", ["person_id"], name: "index_posts_on_person_id", using: :btree
  add_index "posts", ["placeable_type", "placeable_id"], name: "index_posts_on_placeable_type_and_placeable_id", using: :btree

  create_table "programs", force: :cascade do |t|
    t.string   "code"
    t.text     "name"
    t.string   "form"
    t.string   "level"
    t.string   "date"
    t.integer  "university_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "apprent"
    t.string   "profile"
    t.integer  "version"
  end

  add_index "programs", ["university_id"], name: "index_programs_on_university_id", using: :btree

  create_table "subjects", force: :cascade do |t|
    t.integer  "university_id"
    t.string   "name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "person_id"
  end

  add_index "subjects", ["person_id"], name: "index_subjects_on_person_id", using: :btree
  add_index "subjects", ["university_id"], name: "index_subjects_on_university_id", using: :btree

  create_table "teachers", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "teachers", ["post_id"], name: "index_teachers_on_post_id", using: :btree
  add_index "teachers", ["subject_id"], name: "index_teachers_on_subject_id", using: :btree

  create_table "universities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "parent_id"
    t.integer  "current_version",   default: 1
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  add_index "universities", ["parent_id"], name: "index_universities_on_parent_id", using: :btree

  create_table "university_infos", force: :cascade do |t|
    t.text     "address"
    t.text     "fullname"
    t.string   "email"
    t.string   "regdate"
    t.string   "site"
    t.string   "telephone"
    t.text     "worktime"
    t.text     "founder_address"
    t.string   "founder_director"
    t.string   "founder_email"
    t.string   "founder_site"
    t.string   "founder_phone"
    t.text     "founder_name"
    t.datetime "infodate"
    t.integer  "university_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "version"
  end

  add_index "university_infos", ["university_id"], name: "index_university_infos_on_university_id", using: :btree

  add_foreign_key "departments", "universities"
  add_foreign_key "documents", "programs"
  add_foreign_key "documents", "universities"
  add_foreign_key "posts", "people"
  add_foreign_key "programs", "universities"
  add_foreign_key "subjects", "people"
  add_foreign_key "subjects", "universities"
  add_foreign_key "teachers", "posts"
  add_foreign_key "teachers", "subjects"
  add_foreign_key "university_infos", "universities"
end
