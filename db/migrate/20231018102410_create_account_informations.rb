class CreateAccountInformations < ActiveRecord::Migration[7.0]
  def change
    create_view :account_informations
  end
end
