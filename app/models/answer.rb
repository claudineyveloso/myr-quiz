class Answer < ApplicationRecord
  belongs_to :customer
  belongs_to :theme
  belongs_to :maturity
  belongs_to :scenario
end
