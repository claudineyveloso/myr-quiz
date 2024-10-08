class ResultQuizzesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :create ]


  def index
    @chart_data = {
      labels: %w[January February March April May June July],
      datasets: [ {
        label: "My First dataset",
        backgroundColor: "transparent",
        borderColor: "#3B82F6",
        data: [ 37, 83, 78, 54, 12, 5, 99 ]
      } ]
    }

    @chart_options = {
      scales: {
        yAxes: [ {
          ticks: {
            beginAtZero: true
          }
        } ]
      }
    }
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
