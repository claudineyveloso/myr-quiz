class CreateCustomers < ActiveRecord::Migration[7.2]
  def change
    create_table :customers, if_not_exists: true do |t|
      t.string :name, null:false, limit: 100
      t.string :email, null:false, limit: 100
      t.string :phone, null:false, limit: 20
      t.string :company_name, null:false, limit: 100
      t.string :cnpj, null:false, limit: 20

      t.timestamps
    end
    add_index :customers, :email, unique: true
  end
end
