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

ActiveRecord::Schema.define(version: 20141106054649) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contents", force: true do |t|
    t.string   "title"
    t.string   "body"
    t.integer  "view",               default: 0
    t.integer  "download_count",     default: 0
    t.string   "link"
    t.string   "file"
    t.string   "recommend"
    t.boolean  "main",               default: false
    t.boolean  "is_open",            default: false
    t.boolean  "is_remix",           default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "source_info"
    t.text     "iframe_html"
    t.string   "copyright"
    t.string   "type"
    t.string   "remote_content_id"
    t.string   "owner_name"
    t.string   "owner_url"
    t.text     "parent_content_ids"
    t.boolean  "extra_copyright"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
  end

  create_table "redactor_pictures", force: true do |t|
    t.string   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "user_activities", force: true do |t|
    t.integer  "user_id"
    t.integer  "content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "role",                   default: "guest"
    t.string   "name"
    t.string   "nickname"
    t.string   "picture"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "location"
    t.string   "facebook"
    t.string   "facebook_uid"
    t.string   "facebook_credentials"
    t.string   "facebook_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "warnings", force: true do |t|
    t.integer  "content_id"
    t.integer  "user_id"
    t.text     "cause"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
