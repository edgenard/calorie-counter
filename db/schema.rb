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

ActiveRecord::Schema[7.0].define(version: 2022_04_11_013738) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "food_entries", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "meal_id", null: false
    t.integer "calories", null: false
    t.string "name", null: false
    t.datetime "eaten_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meal_id"], name: "index_food_entries_on_meal_id"
    t.index ["user_id"], name: "index_food_entries_on_user_id"
  end

  create_table "meals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.integer "max_entries_per_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_meals_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "max_calories_per_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "food_entries", "meals"
  add_foreign_key "food_entries", "users"
  add_foreign_key "meals", "users"
  add_foreign_key "settings", "users"
end
