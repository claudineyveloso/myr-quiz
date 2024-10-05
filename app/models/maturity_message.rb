class MaturityMessage < ApplicationRecord
  belongs_to :maturity

  validates :maturity_id,
            presence: true

  validates :message,
            presence: true
end
