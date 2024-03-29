# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_03_31_013456) do

  create_table "audiences", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name", null: false
    t.string "email", null: false
    t.string "image"
    t.text "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_audiences_on_confirmation_token", unique: true
    t.index ["email"], name: "index_audiences_on_email", unique: true
    t.index ["reset_password_token"], name: "index_audiences_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_audiences_on_uid_and_provider", unique: true
  end

  create_table "band_rooms", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "band_id", null: false
    t.bigint "room_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["band_id"], name: "index_band_rooms_on_band_id"
    t.index ["room_id", "band_id"], name: "index_band_rooms_on_room_id_and_band_id", unique: true
  end

  create_table "bands", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "image"
    t.text "profile"
    t.string "website"
    t.string "twitter"
    t.text "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_bands_on_confirmation_token", unique: true
    t.index ["email"], name: "index_bands_on_email", unique: true
    t.index ["reset_password_token"], name: "index_bands_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_bands_on_uid_and_provider", unique: true
  end

  create_table "comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "band_id"
    t.bigint "event_id", null: false
    t.bigint "parent_id"
    t.text "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "audience_id"
    t.index ["audience_id"], name: "index_comments_on_audience_id"
    t.index ["band_id"], name: "index_comments_on_band_id"
    t.index ["event_id"], name: "index_comments_on_event_id"
    t.index ["parent_id"], name: "index_comments_on_parent_id"
  end

  create_table "events", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "owner_id"
    t.string "name", null: false
    t.string "flyer"
    t.string "place"
    t.time "open_at"
    t.time "start_at"
    t.integer "ticket_price"
    t.text "content"
    t.text "unregistered_performers"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "reservation", default: false, null: false
    t.date "date", null: false
    t.index ["owner_id"], name: "index_events_on_owner_id"
  end

  create_table "friendships", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "follower_id", null: false
    t.bigint "followed_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["followed_id"], name: "index_friendships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_friendships_on_follower_id_and_followed_id", unique: true
  end

  create_table "likes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "band_id"
    t.bigint "post_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "audience_id"
    t.index ["audience_id", "post_id"], name: "index_likes_on_audience_id_and_post_id", unique: true
    t.index ["band_id", "post_id"], name: "index_likes_on_band_id_and_post_id", unique: true
    t.index ["post_id"], name: "index_likes_on_post_id"
  end

  create_table "lineups", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "performer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id", "performer_id"], name: "index_lineups_on_event_id_and_performer_id", unique: true
    t.index ["performer_id"], name: "index_lineups_on_performer_id"
  end

  create_table "messages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "band_id", null: false
    t.bigint "room_id", null: false
    t.text "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["band_id"], name: "index_messages_on_band_id"
    t.index ["room_id"], name: "index_messages_on_room_id"
  end

  create_table "posts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "format", null: false
    t.string "photo"
    t.string "audio"
    t.string "media_pass"
    t.text "description"
    t.bigint "band_id", null: false
    t.integer "likes_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["band_id"], name: "index_posts_on_band_id"
  end

  create_table "rooms", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tickets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "audience_id", null: false
    t.bigint "event_id", null: false
    t.bigint "band_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["audience_id", "event_id", "band_id"], name: "index_tickets_on_audience_id_and_event_id_and_band_id", unique: true
    t.index ["band_id"], name: "index_tickets_on_band_id"
    t.index ["event_id"], name: "index_tickets_on_event_id"
  end

  add_foreign_key "band_rooms", "bands"
  add_foreign_key "band_rooms", "rooms"
  add_foreign_key "comments", "audiences"
  add_foreign_key "comments", "bands"
  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "comments", "events"
  add_foreign_key "friendships", "bands", column: "followed_id"
  add_foreign_key "friendships", "bands", column: "follower_id"
  add_foreign_key "likes", "audiences"
  add_foreign_key "likes", "bands"
  add_foreign_key "likes", "posts"
  add_foreign_key "lineups", "bands", column: "performer_id"
  add_foreign_key "lineups", "events"
  add_foreign_key "messages", "bands"
  add_foreign_key "messages", "rooms"
  add_foreign_key "posts", "bands"
  add_foreign_key "tickets", "audiences"
  add_foreign_key "tickets", "bands"
  add_foreign_key "tickets", "events"
end
