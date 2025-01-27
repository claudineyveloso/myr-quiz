class MaturityMessage < ApplicationRecord
  belongs_to :maturity
  belongs_to :axi

  before_save :set_default_message

  validates :maturity_id,
            :axi_id,
            presence: true

  validates :message,
            presence: true

  def set_default_message
    self.message ||= ""
  end
end
