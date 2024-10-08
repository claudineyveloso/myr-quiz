class Answer < ApplicationRecord
  belongs_to :customer
  belongs_to :theme
  # belongs_to :maturity
  belongs_to :scenario
  has_one :axi, through: :theme


  scope :by_axis_theme, ->(axis_id, theme_id) {
    joins(theme: :axi)
      .joins(scenario: :maturity)
      .where(themes: { axi_id: axis_id }, themes: { id: theme_id }) # 'themes' usado ao invés de 'axis' na where
      .select("scenarios.id, scenarios.theme_id, scenarios.maturity_id, scenarios.description, axis.name AS axis_name, themes.name AS theme_name, maturities.name AS maturity_name, maturities.value AS maturity_value")
      .order("scenarios.maturity_id ASC")
  }
end
