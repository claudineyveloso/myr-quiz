class CreateAxis < ActiveRecord::Migration[7.2]
  def change
    create_table :axis, if_not_exists: true do |t|
      t.string :name, null: false, limit: 100

      t.timestamps
    end
    add_index :axis, :name, unique: true
  end
end
