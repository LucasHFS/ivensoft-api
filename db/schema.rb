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

ActiveRecord::Schema[7.0].define(version: 2024_02_26_105546) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "organization_id"], name: "index_categories_on_name_and_organization_id", unique: true
    t.index ["organization_id"], name: "index_categories_on_organization_id"
  end

  create_table "deposit_products", force: :cascade do |t|
    t.integer "quantity", default: 0
    t.bigint "product_id", null: false
    t.bigint "deposit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deposit_id"], name: "index_deposit_products_on_deposit_id"
    t.index ["product_id"], name: "index_deposit_products_on_product_id"
  end

  create_table "deposits", force: :cascade do |t|
    t.string "name"
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_deposits_on_organization_id"
  end

  create_table "makes", force: :cascade do |t|
    t.string "name"
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "organization_id"], name: "index_makes_on_name_and_organization_id", unique: true
    t.index ["organization_id"], name: "index_makes_on_organization_id"
  end

  create_table "models", force: :cascade do |t|
    t.string "name"
    t.bigint "organization_id", null: false
    t.bigint "make_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["make_id"], name: "index_models_on_make_id"
    t.index ["name", "organization_id"], name: "index_models_on_name_and_organization_id", unique: true
    t.index ["organization_id"], name: "index_models_on_organization_id"
  end

  create_table "organization_users", force: :cascade do |t|
    t.bigint "organization_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_organization_users_on_organization_id"
    t.index ["user_id"], name: "index_organization_users_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "sku", null: false
    t.boolean "hide_on_sale", default: false
    t.boolean "visible_on_catalog", default: false
    t.integer "sale_price_in_cents", default: 0, null: false
    t.text "comments"
    t.bigint "category_id", null: false
    t.bigint "model_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["model_id"], name: "index_products_on_model_id"
    t.index ["organization_id", "sku"], name: "index_products_on_organization_id_and_sku", unique: true
    t.index ["organization_id"], name: "index_products_on_organization_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "transaction_type", default: 0
    t.integer "quantity"
    t.datetime "transactioned_at"
    t.bigint "deposit_id", null: false
    t.bigint "organization_id", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deposit_id"], name: "index_transactions_on_deposit_id"
    t.index ["organization_id"], name: "index_transactions_on_organization_id"
    t.index ["product_id"], name: "index_transactions_on_product_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "full_name"
    t.string "uid"
    t.string "avatar_url", default: "http://www.gravatar.com/avatar/?d=mp"
    t.string "provider"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vehicle_products", force: :cascade do |t|
    t.integer "quantity", default: 1, null: false
    t.bigint "product_id", null: false
    t.bigint "vehicle_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_vehicle_products_on_product_id"
    t.index ["vehicle_id"], name: "index_vehicle_products_on_vehicle_id"
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "plate"
    t.text "comments"
    t.bigint "model_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["model_id"], name: "index_vehicles_on_model_id"
    t.index ["organization_id"], name: "index_vehicles_on_organization_id"
    t.index ["plate"], name: "index_vehicles_on_plate", unique: true
  end

  add_foreign_key "categories", "organizations"
  add_foreign_key "deposits", "organizations"
  add_foreign_key "makes", "organizations"
  add_foreign_key "models", "makes"
  add_foreign_key "models", "organizations"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "models"
  add_foreign_key "products", "organizations"
end
