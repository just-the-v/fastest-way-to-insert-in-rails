class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.string :role

      t.timestamps
    end
  end
end
