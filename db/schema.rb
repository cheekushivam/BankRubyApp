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

ActiveRecord::Schema.define(version: 2019_06_18_174141) do

  create_table "accountants", force: :cascade do |t|
    t.string "acct_ssnid"
    t.string "acct_name"
    t.integer "acct_age"
    t.string "acct_addr"
    t.string "acct_state"
    t.string "acct_city"
    t.string "acct_designation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "acc_type"
    t.string "acc_balance"
    t.integer "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_accounts_on_customer_id"
  end

  create_table "acct_statements", force: :cascade do |t|
    t.string "action"
    t.string "message"
    t.integer "acc_sender_id"
    t.integer "acc_receiver_id"
    t.string "balance"
    t.integer "cust_sender_id"
    t.integer "cust_receiver_id"
    t.integer "acct_sender_id"
    t.integer "acct_receiver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string "cust_ssnid"
    t.integer "accountant_id"
    t.string "cust_name"
    t.integer "cust_age"
    t.string "cust_addr"
    t.string "cust_state"
    t.string "cust_city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.index ["accountant_id"], name: "index_customers_on_accountant_id"
  end

end
