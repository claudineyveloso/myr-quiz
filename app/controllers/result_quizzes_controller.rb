class ResultQuizzesController < ApplicationController
  def create

    customer_id = params[:customer_id]
    maturity_id = params[:maturity_id]
    axi_id = params[:axi_id]
    average_score = params[:average_score]

    maturity = Maturity.find_by('range_initial <= ? AND range_final >= ?', params[:average_score], params[:average_score])

    average_score = params[:average_score]

    # Cria o registro em ResultQuiz
    result_quiz = ResultQuiz.new(
      customer_id: customer_id,
      maturity_id: maturity.id,
      axi_id: axi_id,
      average_score: average_score
    )

    if result_quiz.save
      render json: { message: "Resultado do quiz salvo com sucesso!" }, status: :ok
    else
      render json: { error: "Erro ao salvar o resultado do quiz" }, status: :unprocessable_entity
    end
  end
end
