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

ActiveRecord::Schema[7.0].define(version: 2023_10_18_102410) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "email"
    t.string "role"
    t.virtual "account_information", type: :string, as: "(((((((((first_name)::text || ' '::text) || (last_name)::text) || ' ('::text) || (role)::text) || ') can be contacted at '::text) || (email)::text) || ' or '::text) || (phone)::text)", stored: true
  end


  create_view "account_informations", sql_definition: <<-SQL
      SELECT concat(accounts.first_name, ' ', accounts.last_name, ' (', accounts.role, '), can be contacted at ', accounts.email, ' or ', accounts.phone) AS concatenated_string
     FROM accounts;
  SQL
end
