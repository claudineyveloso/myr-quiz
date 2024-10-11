class CreateMaturities < ActiveRecord::Migration[7.2]
  def change
    create_table :maturities, if_not_exists: true do |t|
      t.string :name, null: false, limit: 100
      t.decimal :value, precision: 2, scale: 1, null: false

      t.timestamps
    end
    add_index :maturities, :name, unique: true
  end
end
