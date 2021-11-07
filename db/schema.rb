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

ActiveRecord::Schema.define(version: 2021_11_07_002815) do

  create_table "rushings", force: :cascade do |t|
    t.string "player_name"
    t.string "team_abbr"
    t.string "pos"
    t.integer "attempts"
    t.decimal "attempts_per_game", precision: 1, scale: 4
    t.integer "yds"
    t.decimal "avg_yds", precision: 1, scale: 4
    t.integer "yds_per_game"
    t.integer "total_touchdowns"
    t.integer "longest"
    t.boolean "longest_t", default: false
    t.integer "first_downs"
    t.decimal "first_downs_percentage", precision: 1, scale: 4
    t.integer "twenty_plus"
    t.integer "forty_plus"
    t.integer "fumbles"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
