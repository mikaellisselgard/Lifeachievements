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

ActiveRecord::Schema.define(version: 20151118085415) do

  create_table "achievements", force: :cascade do |t|
    t.text     "description"
    t.integer  "score"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "achievements_bucket_lists", id: false, force: :cascade do |t|
    t.integer "achievement_id", null: false
    t.integer "bucket_list_id", null: false
  end

  create_table "achievements_categories", id: false, force: :cascade do |t|
    t.integer "category_id",    null: false
    t.integer "achievement_id", null: false
  end

  create_table "bucket_lists", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "bucket_lists", ["user_id"], name: "index_bucket_lists_on_user_id"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medals", force: :cascade do |t|
    t.string   "type"
    t.string   "image"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "medals", ["user_id"], name: "index_medals_on_user_id"

  create_table "posts", force: :cascade do |t|
    t.string   "image"
    t.text     "message"
    t.integer  "user_id"
    t.integer  "achievement_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "height"
    t.string   "width"
  end

  add_index "posts", ["achievement_id"], name: "index_posts_on_achievement_id"
  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "avatar"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
