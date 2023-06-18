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

ActiveRecord::Schema[7.0].define(version: 2023_06_18_090605) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "houses", force: :cascade do |t|
    t.string "address"
    t.geography "location", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.bigint "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_houses_on_creator_id"
    t.index ["location"], name: "index_houses_on_location", using: :gist
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "creator_id", null: false
    t.bigint "house_id", null: false
    t.string "title", null: false
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_posts_on_creator_id"
    t.index ["house_id"], name: "index_posts_on_house_id"
  end

  create_table "user_house_subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "house_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["house_id"], name: "index_user_house_subscriptions_on_house_id"
    t.index ["user_id"], name: "index_user_house_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "surname"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "houses", "users", column: "creator_id"
  add_foreign_key "posts", "houses"
  add_foreign_key "posts", "users", column: "creator_id"
  add_foreign_key "user_house_subscriptions", "houses"
  add_foreign_key "user_house_subscriptions", "users"
end
