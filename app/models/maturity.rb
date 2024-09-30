class Maturity < ApplicationRecord

  has_many :scenarios
  has_many :answer

  validates :name,
            length: { maximum: 100 },
            presence: true

end
