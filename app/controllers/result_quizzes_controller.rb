class ResultQuizzesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :create ]


  def index
    customer_id = 12 # params[:customer_id]
    if customer_id.present?
      @axi_ids = Axi.order(:id).pluck(:id)
      @results = []

      @axi_ids.each do |axi_id|
        # Busca os resultados do quiz para o customer_id e axi_id
        results_for_axi = ResultQuiz.by_axi_customer(axi_id, customer_id)
        # Verifica se há resultados válidos antes de adicionar ao array
        unless results_for_axi.empty?
          first_result = results_for_axi[0]
          @results << {
            axi_id: axi_id,
            results: { average_score: format("%.2f", first_result.average_score), id: first_result.id }
          }
        end
      end

      respond_to do |format|
        format.html # Renderiza a view index.html.erb
        format.json { render json: @results, status: :ok  } # Retorna os resultados em JSON
      end

    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: "Customer ID não fornecido" }
        format.json { render json: { error: "Customer ID não fornecido" }, status: :unprocessable_entity }
      end
    end
  end

  def create
    customer_id = params[:customer_id]
    maturity_id = params[:maturity_id]
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
      render json: { error: "Erro ao salvar o resultado do quiz" }, status: :unprocessable_entity
    end
  end
end
