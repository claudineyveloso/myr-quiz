class QuizProcessor
  def initialize(responses)
    @responses = responses
    @total_maturity_score = 0
  end

  def process
    customer_id = nil
    axi_id = nil

    @responses.each do |response|
      customer_id = response[:customer_id]
      axi_id = response[:axi_id]
      theme_id = response[:theme_id]
      scenario_id = response[:scenario_id]

      maturity_value_sum = Scenario.joins(:maturity)
                                   .where(id: scenario_id)
                                   .sum("maturities.value")

      @total_maturity_score += maturity_value_sum

      # Cria a resposta no banco de dados
      Answer.create(customer_id: customer_id, theme_id: theme_id, scenario_id: scenario_id)
    end

    average_score = calculate_average
    maturity = find_maturity(average_score)

    ResultQuiz.create(customer_id: customer_id, maturity_id: maturity.id, average_score: average_score, axi_id: axi_id.to_i)

    average_score
  end

  def get_next_axi_id(axi_id)
    ids = Axi.where("id > ?", axi_id).order(:id).pluck(:id)
    ids.first
  end

  private

  def calculate_average
    @total_maturity_score.to_f / 6
  end

  def find_maturity(average_score)
    Maturity.find_by("range_initial <= ? AND range_final >= ?", average_score, average_score)
  end
end
