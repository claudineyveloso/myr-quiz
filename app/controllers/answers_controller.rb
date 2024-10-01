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
  end

  def axi_data
    axi = Axi.by_id(params[:id]).first
    
    if axi
      render json: { id: axi.id, name: axi.name }
    else
      render json: { error: "Axi not found" }, status: :not_found
    end
  end

  def background_color
    case name.downcase
    when 'environmental'
      '#d1d58a'
    when 'social'
      '#02747F'
    when 'governance'
      '#B5838D'
    else
      '#ffffff'
    end
  end



end
