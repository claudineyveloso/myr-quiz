class CreateThemes < ActiveRecord::Migration[7.2]
  def change
    create_table :themes do |t|
      t.references :axi, null: false, foreign_key: true
      t.string :name, null: false, limit: 100

      t.timestamps
    end
    add_index :themes, :name, unique: true
  end
end
