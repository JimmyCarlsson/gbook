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

ActiveRecord::Schema.define(version: 2020_09_23_090031) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "authentication_token"
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "bookings", id: :serial, force: :cascade do |t|
    t.string "booking_type"
    t.string "name"
    t.string "contact_person"
    t.string "email"
    t.string "phone_nr"
    t.integer "tickets"
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.datetime "deleted_at"
    t.integer "discount"
    t.text "discount_message"
    t.text "message"
    t.boolean "paid", default: false
    t.text "memo"
    t.datetime "due_date"
    t.datetime "delivery_date"
    t.string "address_street", default: ""
    t.string "address_zip", default: ""
    t.string "address_city", default: ""
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.datetime "date"
    t.string "name"
    t.string "description"
    t.integer "price"
    t.integer "seats"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "tax6", default: 0
    t.integer "tax12", default: 0
    t.integer "tax25", default: 0
    t.boolean "hidden", default: false
    t.integer "items", default: [], array: true
    t.integer "ticket_limit_lower"
    t.integer "ticket_limit_higher"
    t.text "ticket_limit_lower_msg"
    t.text "ticket_limit_higher_msg"
    t.boolean "unique_ticket"
  end

  create_table "items", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "price"
    t.integer "tax6"
    t.integer "tax12"
    t.integer "tax25"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_rows", id: :serial, force: :cascade do |t|
    t.integer "booking_id"
    t.string "name"
    t.string "description"
    t.integer "price"
    t.integer "tax6"
    t.integer "tax12"
    t.integer "tax25"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount"
  end

end
