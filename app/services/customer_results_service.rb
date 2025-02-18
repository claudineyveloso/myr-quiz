class CustomerResultsService
  attr_reader :customer_id,
    :axi_ids,
    :results,
    :messages,
    :axis_environmental,
    :axis_social,
    :axis_governance,
    :customer,
    :total_average_score,
    :maturity

  COLOR_CODES = {
    1 => "#F1F2D4",
    2 => "#D6F0F2",
    3 => "#E6CBE3"
  }

  def initialize(customer_id)
    @customer_id = customer_id.to_i
    @axi_ids = Axi.order(:id).pluck(:id)
    @results = []
    @messages = []
    @axis_environmental = []
    @axis_social = []
    @axis_governance = []
    @customer = []
    @total_average_score = 0

    process_results if @customer_id.present?
  end

  private

  def process_results
    @axi_ids.each do |axi_id|
      results_for_axi = ResultQuiz.by_axi_customer(axi_id, @customer_id)
      @customer = results_for_axi

      unless results_for_axi.empty?
        first_result = results_for_axi[0]
        @total_average_score += first_result.average_score.to_f
        @results << {
          axi_id: axi_id,
          results: {
            average_score: format("%.2f", first_result.average_score),
            id: first_result.id,
            axi_name: first_result.axi.name
          }
        }

        process_themes(axi_id)
        process_messages(axi_id, first_result)
      end
    end

    calculate_maturity
  end

  def process_themes(axi_id)
    themes_for_axi = Answer.by_axis_by_customer(axi_id, @customer_id)
    themes_for_axi.each do |theme|
      data = { theme_id: theme.id, theme_name: theme.theme.name, average_score: format("%.2f", theme.maturity_value) }
      case axi_id
      when 1 then @axis_environmental << data
      when 2 then @axis_social << data
      when 3 then @axis_governance << data
      end
    end
  end

  def process_messages(axi_id, first_result)
    maturity_messages = MaturityMessage.joins(:axi, :maturity)
                                       .where(axi_id: first_result.axi_id, maturity_id: first_result.maturity_id)

    maturity_messages.each do |message|
      @messages << {
        message: message,
        color_code: COLOR_CODES[axi_id]
      }
    end
  end

  def calculate_maturity
    average_score = (@total_average_score / 3 * 10).floor / 10.0
    @maturity = Maturity.find_by("range_initial <= ? AND range_final >= ?", average_score, average_score)
  end

end
