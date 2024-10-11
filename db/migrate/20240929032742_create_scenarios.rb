class CreateScenarios < ActiveRecord::Migration[7.2]
  def change
    create_table :scenarios, if_not_exists: true do |t|
      t.references :theme, null: false, foreign_key: true
      t.references :maturity, null: false, foreign_key: true
      t.text :description, null: false

      t.timestamps
    end
  end
end
