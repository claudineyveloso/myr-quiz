class AddDescriptionToAxis < ActiveRecord::Migration[7.2]
  def change
    add_column :axis, :description, :text, null: false, default: ""
  end
end
