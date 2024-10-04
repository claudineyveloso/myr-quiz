class AddDescriptionToScenario < ActiveRecord::Migration[7.2]
  def change
    add_column :scenarios, :description_result, :text
  end
end
