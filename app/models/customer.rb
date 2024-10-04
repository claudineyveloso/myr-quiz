class Customer < ApplicationRecord
  has_one :answer
  has_many :result_quizzes

  validates :name,
            :email,
            :company_name,
            length: { maximum: 100 },
            presence: true

  validates :phone,
            :cnpj,
            length: { maximum: 20 },
            presence: true


end
