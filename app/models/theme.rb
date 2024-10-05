class Theme < ApplicationRecord
  belongs_to :axi
  has_many :scenarios
  has_many :answer

  validates :axi_id,
            presence: true

  validates :name,
            length: { maximum: 100 },
            presence: true
end
