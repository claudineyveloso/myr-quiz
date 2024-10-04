class ResultQuiz < ApplicationRecord
  belongs_to :customer
  belongs_to :axi
  belongs_to :maturity
end
