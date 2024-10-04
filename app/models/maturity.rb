class Maturity < ApplicationRecord

  has_many :scenarios
  has_many :result_quizzes

  # has_many :answer

  validates :name,
            length: { maximum: 100 },
            presence: true

  validates :range_initial,
            :range_final,
            presence: true

end
