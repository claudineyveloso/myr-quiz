class AddDescriptionToMaturity < ActiveRecord::Migration[7.2]
  def change
    add_column :maturities, :description_result, :text
  end
end
