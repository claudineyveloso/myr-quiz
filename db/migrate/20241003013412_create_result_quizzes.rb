class CreateResultQuizzes < ActiveRecord::Migration[7.2]
  def change
    create_table :result_quizzes, if_not_exists: true do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :axi, null: false, foreign_key: true
      t.references :maturity, null: false, foreign_key: true
      t.decimal :average_score, null: false, default: 0

      t.timestamps
    end
  end
end
