class AddFinishedQuizToCustomer < ActiveRecord::Migration[7.2]
  def change
    add_column :customers, :finished_quiz, :boolean, null: false, default: false
  end
end
