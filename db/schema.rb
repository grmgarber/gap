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

ActiveRecord::Schema.define(version: 2019_07_13_040557) do

# Could not dump table "addresses" because of following StandardError
#   Unknown type 'reference' for column 'property_id'

  create_table "expenses_records", force: :cascade do |t|
    t.decimal "marketing", precision: 11, scale: 2
    t.decimal "tax", precision: 11, scale: 2
    t.decimal "insurance", precision: 11, scale: 2
    t.decimal "repairs", precision: 11, scale: 2
    t.decimal "admin", precision: 11, scale: 2
    t.decimal "payroll", precision: 11, scale: 2
    t.decimal "utility", precision: 11, scale: 2
    t.decimal "management", precision: 11, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "properties", force: :cascade do |t|
    t.float "cap_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quotes", force: :cascade do |t|
    t.integer "property_id"
    t.decimal "ref_rate", precision: 4, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.index ["property_id"], name: "index_quotes_on_property_id"
  end

  create_table "units", force: :cascade do |t|
    t.decimal "monthly_rent", precision: 11, scale: 2
    t.string "unit_number"
    t.boolean "vacancy"
    t.integer "nbr_bedrooms"
    t.integer "nbr_bathrooms"
    t.integer "annual_total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
