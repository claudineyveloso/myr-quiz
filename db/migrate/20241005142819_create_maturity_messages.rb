class CreateMaturityMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :maturity_messages, if_not_exists: true do |t|
      t.references :axi, null: false, foreign_key: true
      t.references :maturity, null: false, foreign_key: true
      t.text :message, null: false

      t.timestamps
    end
  end
end
