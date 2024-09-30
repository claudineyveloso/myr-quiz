class Scenario < ApplicationRecord
  belongs_to :theme
  belongs_to :maturity
  has_many :answer

  validates :theme_id,
            :maturity_id,
            presence: true

  validates :description,
            presence: true

  # scope :quiz_by_axis, ->(axis_id) {
  #   joins(theme: :axi)
  #   .joins(:maturity)
  #   .where(axis: { id: axis_id })
  #   .select('scenarios.id, scenarios.theme_id, scenarios.maturity_id, scenarios.description, axis.name AS axis_name, themes.name AS theme_name, maturities.name AS maturity_name, maturities.value AS maturity_value')
  # }
  #
  scope :quiz_by_axis, ->(axis_id, theme_id) {
    joins(theme: :axi)
      .joins(:maturity)
      .where(themes: { axi_id: axis_id }, themes: { id: theme_id }) # 'themes' usado ao invés de 'axis' na where
      .select('scenarios.id, scenarios.theme_id, scenarios.maturity_id, scenarios.description, axis.name AS axis_name, themes.name AS theme_name, maturities.name AS maturity_name, maturities.value AS maturity_value')
  }

end
