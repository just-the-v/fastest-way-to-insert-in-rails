class AddDeleteCascade < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :missions, :accounts
    add_foreign_key :missions, :accounts, on_delete: :cascade
    remove_foreign_key :tasks, :missions
    add_foreign_key :tasks, :missions, on_delete: :cascade
  end
end
