# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_13_170227) do

  create_table "achievements", force: :cascade do |t|
    t.string "achievement_name"
    t.integer "difficulty"
    t.string "condition"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "runs", force: :cascade do |t|
    t.integer "score"
    t.integer "turns"
    t.integer "levels_cleared"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "max_combo", default: 0
  end

  create_table "unlocks", force: :cascade do |t|
    t.integer "run_id"
    t.integer "achievement_id"
    t.datetime "created_at", default: "2019-09-10 23:04:08", null: false
    t.datetime "updated_at", default: "2019-09-10 23:04:08", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "symbol"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "age"
  end

end
