class ResultQuizzesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :create]

  def index
    customer_id = cookies[:customer_id].to_i
    if customer_id.present?
      @axi_ids = Axi.order(:id).pluck(:id)
      @results = []
      @messages = []
      @axis_environmental = []
      @axis_social = []
      @axis_governance = []
      @customer = []

      total_average_score = 0

      color_codes = {
        1 => "#F1F2D4",
        2 => "#D6F0F2",
        3 => "#E6CBE3"
      }

      @axi_ids.each do |axi_id|
        # Busca os resultados do quiz para o customer_id e axi_id
        results_for_axi = ResultQuiz.by_axi_customer(axi_id, customer_id)
        @customer = results_for_axi
        # Verifica se há resultados válidos antes de adicionar ao array
        unless results_for_axi.empty?

          first_result = results_for_axi[0]
          total_average_score += first_result.average_score.to_f

          @results << {
            axi_id: axi_id,
            results: {average_score: format("%.2f", first_result.average_score), id: first_result.id, axi_name: first_result.axi.name}
          }

          themes_for_axi = Answer.by_axis_by_customer(axi_id, customer_id)
          themes_for_axi.each do |theme|
            case axi_id
            when 1
              @axis_environmental << {theme_id: theme.id, theme_name: theme.theme.name, average_score: format("%.2f", theme.maturity_value)}
            when 2
              @axis_social << {theme_id: theme.id, theme_name: theme.theme.name, average_score: format("%.2f", theme.maturity_value)}
            when 3
              @axis_governance << {theme_id: theme.id, theme_name: theme.theme.name, average_score: format("%.2f", theme.maturity_value)}
            end
          end

          maturity_messages = MaturityMessage.joins(:axi, :maturity)
            .where(axi_id: first_result.axi_id, maturity_id: first_result.maturity_id)
          maturity_messages.each do |message|
            @messages << {
              message: message,
              color_code: color_codes[axi_id] # Define a cor com base no axi_id
            }
          end
        end
      end

      average_score = (total_average_score / 3 * 10).floor / 10.0
      maturity = Maturity.find_by("range_initial <= ? AND range_final >= ?", average_score, average_score)
      respond_to do |format|
        format.html # Renderiza a view index.html.erb
        format.pdf do
          render pdf: "relatorio_#{customer_id}", # Nome do arquivo PDF
            locals: {results: @results, messages: @messages, total_average_score: total_average_score, maturity: maturity, customer: @customer}
        end
        format.json { render json: {results: @results, messages: @messages, total_average_score: total_average_score, maturity_name: maturity.name, maturity_description: maturity.description_result}, status: :ok }
      end

    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: "Customer ID não fornecido" }
        format.json { render json: {error: "Customer ID não fornecido"}, status: :unprocessable_entity }
      end
    end
  end

  def create
    customer_id = params[:customer_id]
    params[:maturity_id]
    axi_id = params[:axi_id]
    average_score = params[:average_score]

    # Cria o registro em ResultQuiz
    result_quiz = ResultQuiz.new(
      customer_id: customer_id,
      maturity_id: maturity.id,
      axi_id: axi_id,
      average_score: average_score
    )

    if result_quiz.save
      redirect_to axi_answers_path(id: 2), notice: "Resultado do quiz salvo com sucesso!"
    else
      render json: {error: "Erro ao salvar o resultado do quiz"}, status: :unprocessable_entity
    end
  end
end
