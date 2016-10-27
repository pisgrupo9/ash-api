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

ActiveRecord::Schema.define(version: 20161027002739) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "adopters", force: :cascade do |t|
    t.string   "first_name",                        null: false
    t.string   "last_name",                         null: false
    t.string   "ci",                                null: false
    t.string   "email",             default: ""
    t.string   "phone",                             null: false
    t.string   "house_description", default: ""
    t.boolean  "blacklisted",       default: false, null: false
    t.string   "home_address",                      null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "adoptions", force: :cascade do |t|
    t.integer  "animal_id",  null: false
    t.integer  "adopter_id", null: false
    t.date     "date",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "adoptions", ["adopter_id"], name: "index_adoptions_on_adopter_id", using: :btree
  add_index "adoptions", ["animal_id"], name: "index_adoptions_on_animal_id", unique: true, using: :btree

  create_table "animals", force: :cascade do |t|
    t.string   "chip_num"
    t.string   "name",           null: false
    t.string   "race"
    t.integer  "sex",            null: false
    t.boolean  "vaccines"
    t.boolean  "castrated"
    t.date     "admission_date", null: false
    t.date     "birthdate",      null: false
    t.date     "death_date"
    t.integer  "species_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "profile_image"
    t.integer  "weight"
    t.string   "type"
    t.boolean  "adopted"
  end

  add_index "animals", ["species_id"], name: "index_animals_on_species_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "adopter_id"
    t.string   "text",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["adopter_id"], name: "index_comments_on_adopter_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
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

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "events", force: :cascade do |t|
    t.string  "name",        null: false
    t.string  "description", null: false
    t.date    "date",        null: false
    t.integer "animal_id",   null: false
  end

  add_index "events", ["animal_id"], name: "index_events_on_animal_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "file"
    t.integer  "animal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "event_id"
  end

  add_index "images", ["animal_id"], name: "index_images_on_animal_id", using: :btree
  add_index "images", ["event_id"], name: "index_images_on_event_id", using: :btree

  create_table "reports", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "type_file"
    t.integer  "state"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "reports", ["user_id"], name: "index_reports_on_user_id", using: :btree

  create_table "species", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "adoptable",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "authentication_token",   default: ""
    t.string   "first_name",                             null: false
    t.string   "last_name",                              null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "phone"
    t.boolean  "account_active",         default: false
    t.integer  "permissions",            default: 0
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "adoptions", "adopters"
  add_foreign_key "adoptions", "animals"
  add_foreign_key "animals", "species"
  add_foreign_key "comments", "adopters"
  add_foreign_key "comments", "users"
  add_foreign_key "events", "animals"
  add_foreign_key "images", "animals"
  add_foreign_key "images", "events"
  add_foreign_key "reports", "users"
end
