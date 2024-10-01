class AnswersController < ApplicationController

  skip_before_action :authenticate_user!, only: [:new, :create, :start, :axi_data, :step, :axi]
  def new
  end

  def create
  end

  def start
    @axi = Axi.by_id(1).first
  end

  def step
    @step = params[:step]
  end

  def axi
    @axi = Axi.find(params[:id])
    
    # Corrigido para carregar todos os temas relacionados ao axi
    @themes = Theme.where(axi_id: @axi.id)

    Rails.logger.info "Themes encontrados: #{@themes.inspect}" # Isso agora vai funcionar corretamente
    
    # Seleciona o primeiro tema da coleção de temas
    if @themes.any?
      @theme = @themes.first
      @answers = Scenario.quiz_by_axis(@axi.id, @theme.id)
    else
      @answers = [] # Caso não haja temas
    end
  end

  def quiz_by_theme
    axi_id = params[:axi_id]
    theme_id = params[:theme_id]

    # Use o scope para buscar as respostas com base no eixo e tema
    answers = Scenario.quiz_by_axis(axi_id, theme_id)

    # Retorna as respostas no formato JSON
    render json: { answers: answers }
  end

  def axi_data
    axi = Axi.by_id(params[:id]).first
    
    if axi
      render json: { id: axi.id, name: axi.name }
    else
      render json: { error: "Axi not found" }, status: :not_found
    end
  end

end
