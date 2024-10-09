class AddSatisfactionScoreToCustomer < ActiveRecord::Migration[7.2]
  def change
    add_column :customers, :satisfaction_score, :integer, null: false, default: 0
  end
end
