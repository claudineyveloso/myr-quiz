class AddRangeToMaturity < ActiveRecord::Migration[7.2]
  def change
    add_column :maturities, :range_initial, :decimal, precision: 2, scale: 1, null: false, default: 0
    add_column :maturities, :range_final, :decimal, precision: 2, scale: 1, null: false, default: 0
  end
end
