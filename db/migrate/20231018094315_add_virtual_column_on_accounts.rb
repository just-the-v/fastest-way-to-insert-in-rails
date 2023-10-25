class AddVirtualColumnOnAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :account_information, :virtual, type: :string,
               as: "first_name || ' ' || last_name || ' (' || role || ') can be contacted at ' ||  email || ' or ' || phone", #
               stored: true
  end
end
