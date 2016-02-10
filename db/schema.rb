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

ActiveRecord::Schema.define(version: 20160210130556) do

  create_table "achievements", force: :cascade do |t|
    t.text     "description", limit: 65535
    t.integer  "score",       limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "user_id",     limit: 4
  end

  add_index "achievements", ["user_id"], name: "index_achievements_on_user_id", using: :btree

  create_table "achievements_bucket_lists", id: false, force: :cascade do |t|
    t.integer "achievement_id", limit: 4, null: false
    t.integer "bucket_list_id", limit: 4, null: false
  end

  create_table "achievements_categories", id: false, force: :cascade do |t|
    t.integer "category_id",    limit: 4, null: false
    t.integer "achievement_id", limit: 4, null: false
  end

  create_table "bucket_lists", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "bucket_lists", ["user_id"], name: "index_bucket_lists_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string   "comment",        limit: 255
    t.integer  "imageable_id",   limit: 4
    t.string   "imageable_type", limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "user_id",        limit: 4
  end

  add_index "comments", ["imageable_type", "imageable_id"], name: "index_comments_on_imageable_type_and_imageable_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "follows", force: :cascade do |t|
    t.integer  "followable_id",   limit: 4,                   null: false
    t.string   "followable_type", limit: 255,                 null: false
    t.integer  "follower_id",     limit: 4,                   null: false
    t.string   "follower_type",   limit: 255,                 null: false
    t.boolean  "blocked",                     default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables", using: :btree
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows", using: :btree

  create_table "likes", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "user_id",    limit: 4
    t.integer  "post_id",    limit: 4
  end

  create_table "medals", force: :cascade do |t|
    t.string   "type",       limit: 255
    t.string   "image",      limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "medals", ["user_id"], name: "index_medals_on_user_id", using: :btree

  create_table "notices", force: :cascade do |t|
    t.string   "message",     limit: 255
    t.datetime "seen"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id",     limit: 4
    t.string   "link",        limit: 255
    t.string   "notice_type", limit: 255
  end

  create_table "notices_users", id: false, force: :cascade do |t|
    t.integer "user_id",   limit: 4, null: false
    t.integer "notice_id", limit: 4, null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string   "image",          limit: 255
    t.integer  "user_id",        limit: 4
    t.integer  "achievement_id", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "height",         limit: 255
    t.string   "width",          limit: 255
    t.integer  "likes_count",    limit: 4
    t.string   "video",          limit: 255
    t.float    "longitude",      limit: 24
    t.float    "latitude",       limit: 24
    t.integer  "status",         limit: 4
  end

  add_index "posts", ["achievement_id"], name: "index_posts_on_achievement_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "reports", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "post_id",    limit: 4
    t.integer  "status",     limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "reports", ["post_id"], name: "index_reports_on_post_id", using: :btree
  add_index "reports", ["user_id"], name: "index_reports_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "avatar",                 limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "reports", "posts"
  add_foreign_key "reports", "users"
end
