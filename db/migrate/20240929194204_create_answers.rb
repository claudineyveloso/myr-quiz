class CreateAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :answers do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :theme, null: false, foreign_key: true
      t.references :maturity, null: false, foreign_key: true
      t.references :scenario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
