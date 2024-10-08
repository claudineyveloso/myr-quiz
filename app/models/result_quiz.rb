class ResultQuiz < ApplicationRecord
  belongs_to :customer
  belongs_to :axi
  belongs_to :maturity

  scope :by_axi_customer, ->(axi_id, customer_id) {
    joins(:axi)
    .joins(:customer)
    .where(axi_id: axi_id, customer_id: customer_id)
  }
end
