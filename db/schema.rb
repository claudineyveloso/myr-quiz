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

ActiveRecord::Schema[7.2].define(version: 2024_09_29_194204) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "theme_id", null: false
    t.bigint "maturity_id", null: false
    t.bigint "scenario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_answers_on_customer_id"
    t.index ["maturity_id"], name: "index_answers_on_maturity_id"
    t.index ["scenario_id"], name: "index_answers_on_scenario_id"
    t.index ["theme_id"], name: "index_answers_on_theme_id"
  end

  create_table "axis", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_axis_on_name", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "email", limit: 100, null: false
    t.string "phone", limit: 20, null: false
    t.string "company_name", limit: 100, null: false
    t.string "cnpj", limit: 20, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_customers_on_email", unique: true
  end

  create_table "maturities", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.decimal "value", precision: 2, scale: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_maturities_on_name", unique: true
  end

  create_table "scenarios", force: :cascade do |t|
    t.bigint "theme_id", null: false
    t.bigint "maturity_id", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["maturity_id"], name: "index_scenarios_on_maturity_id"
    t.index ["theme_id"], name: "index_scenarios_on_theme_id"
  end

  create_table "themes", force: :cascade do |t|
    t.bigint "axi_id", null: false
    t.string "name", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["axi_id"], name: "index_themes_on_axi_id"
    t.index ["name"], name: "index_themes_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.boolean "is_active", default: true, null: false
    t.integer "user_type", default: 1, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "answers", "customers"
  add_foreign_key "answers", "maturities"
  add_foreign_key "answers", "scenarios"
  add_foreign_key "answers", "themes"
  add_foreign_key "scenarios", "maturities"
  add_foreign_key "scenarios", "themes"
  add_foreign_key "themes", "axis", column: "axi_id"
end
