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

ActiveRecord::Schema.define(version: 2024_08_14_224739) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "lgr"
    t.bigint "nro"
    t.string "cpl"
    t.string "neighborhood"
    t.bigint "mun"
    t.string "uf"
    t.string "cep"
    t.bigint "cod_country"
    t.string "country"
    t.string "phone"
    t.bigint "company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_addresses_on_company_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "document"
    t.string "name"
    t.string "fantasy"
    t.bigint "ie"
    t.integer "ind_ie"
    t.integer "crt"
    t.integer "entity_type"
    t.bigint "document_info_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["document_info_id"], name: "index_companies_on_document_info_id"
  end

  create_table "document_infos", force: :cascade do |t|
    t.string "serie"
    t.string "nnf"
    t.datetime "dhemi"
    t.bigint "report_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id"], name: "index_document_infos_on_report_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.bigint "ncm"
    t.bigint "cfop"
    t.string "unity"
    t.float "quantity"
    t.float "value"
    t.bigint "report_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id"], name: "index_products_on_report_id"
  end

  create_table "reports", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "xml_file"
  end

  create_table "taxes", force: :cascade do |t|
    t.float "icms"
    t.float "ipi"
    t.float "pis"
    t.float "cofins"
    t.bigint "report_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id"], name: "index_taxes_on_report_id"
  end

  create_table "totalizers", force: :cascade do |t|
    t.float "total_products"
    t.float "total_taxes"
    t.bigint "report_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id"], name: "index_totalizers_on_report_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "addresses", "companies"
  add_foreign_key "companies", "document_infos"
  add_foreign_key "document_infos", "reports"
  add_foreign_key "products", "reports"
  add_foreign_key "taxes", "reports"
  add_foreign_key "totalizers", "reports"
end
