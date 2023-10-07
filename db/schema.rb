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

ActiveRecord::Schema[7.1].define(version: 2023_10_07_184512) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "transaction_status", ["approved", "reversed", "refunded", "error"]
  create_enum "user_status", ["active", "inactive"]

  create_table "payments", force: :cascade do |t|
    t.decimal "amount"
    t.string "monetizable_type", null: false
    t.bigint "monetizable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["monetizable_type", "monetizable_id"], name: "index_payments_on_monetizable"
  end

  create_table "transactions", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.enum "status", default: "approved", null: false, enum_type: "transaction_status"
    t.string "customer_email", null: false
    t.string "customer_phone"
    t.bigint "merchant_id", null: false
    t.bigint "reference_transaction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "transaction_type", default: "Transaction", null: false
    t.index ["merchant_id"], name: "index_transactions_on_merchant_id"
    t.index ["reference_transaction_id"], name: "index_transactions_on_reference_transaction_id"
    t.index ["status"], name: "index_transactions_on_status"
    t.index ["uuid"], name: "index_transactions_on_uuid", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "status", default: "active", null: false, enum_type: "user_status"
    t.string "name", null: false
    t.text "description"
    t.decimal "total_transaction_sum", default: "0.0", null: false
    t.string "user_type", default: "Merchant", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "transactions", "transactions", column: "reference_transaction_id"
end
