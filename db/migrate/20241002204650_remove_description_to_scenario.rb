class RemoveDescriptionToScenario < ActiveRecord::Migration[7.2]
  def change
    remove_column :scenarios, :description_result
  end
end
