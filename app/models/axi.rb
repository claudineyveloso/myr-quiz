class Axi < ApplicationRecord
  has_many :themes  
  validates :name,
            length: { maximum: 100 },
            presence: true

  scope :by_id, ->(id) { where(id: id) }

end
