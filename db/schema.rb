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

ActiveRecord::Schema.define(version: 20160929221735) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "animals", force: :cascade do |t|
    t.string   "chip_num"
    t.string   "name",           null: false
    t.string   "race"
    t.integer  "sex",            null: false
    t.boolean  "vaccines",       null: false
    t.boolean  "castrated",      null: false
    t.date     "admission_date", null: false
    t.date     "birthdate",      null: false
    t.date     "death_date"
    t.integer  "species_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "profile_image"
    t.integer  "weight"
  end

  add_index "animals", ["species_id"], name: "index_animals_on_species_id", using: :btree

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

  create_table "species", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "animals", "species"
  add_foreign_key "events", "animals"
  add_foreign_key "images", "animals"
  add_foreign_key "images", "events"
end
