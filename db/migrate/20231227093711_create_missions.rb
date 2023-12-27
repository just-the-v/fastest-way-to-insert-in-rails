class CreateMissions < ActiveRecord::Migration[7.0]
  def change
    create_table :missions do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name
      t.date :due_date

      t.timestamps
    end
  end
end
