class Theme < ApplicationRecord
  belongs_to :axi
  has_many :scenarios
  has_many :answer

  scope :by_axi_id, ->(axi_id) {
    joins(:axi)
    .where(themes: { axi_id: axi_id })
  }

  validates :axi_id,
            presence: true

  validates :name,
            length: { maximum: 100 },
            presence: true
end
