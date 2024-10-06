class MaturityMessage < ApplicationRecord
  belongs_to :maturity
  belongs_to :axi

  validates :maturity_id,
            :axi_id,
            presence: true

  validates :message,
            presence: true
end
