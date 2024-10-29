class AddAccessUrlToCustomers < ActiveRecord::Migration[7.2]
  def change
    add_column :customers, :access_url, :string, null: false, default: ""
    execute "UPDATE customers SET access_url = 'esgsolutions.com.br'"
  end
end
