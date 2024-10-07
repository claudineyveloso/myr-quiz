class ResultQuizzesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :create ]

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
