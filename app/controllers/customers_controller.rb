class CustomersController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :new, :create, :show, :check_email ]

  def new
    @customer = Customer.new # Inicializa um novo objeto Customer
  end

  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      cookies[:customer_id] = @customer.id
      Rails.logger.info "Cookie set: #{cookies[:customer_id]}"
      # Redireciona para a ação 'index' ou outra página de sua escolha
      redirect_to start_answers_path, notice: "Cliente criado com sucesso."
    else
      # Renderiza a nova página de formulário se houver erros
      render :new
    end
  end

  def show
  end

  def check_email
    email = params[:email]
    customer = Customer.find_by(email: email)

    if customer
      if customer.finished_quiz
        unless cookies[:customer_id]
          # Se o cookie não existir, cria o cookie com o ID do customer
          cookies[:customer_id] = { value: customer.id, expires: 1.day.from_now } # Defina o tempo de expiração conforme necessário
        end
        render json: { status: "finished", message: "Este e-mail já finalizou o questionário." }
      else
        render json: {
          status: "not_finished",
          message: "O questionário não foi finalizado. Você pode prosseguir.",
          customer: {
            phone: customer.phone,
            company_name: customer.company_name,
            cnpj: customer.cnpj
          }
        }
        # Destroy all Answer of Customer
        Answer.where(customer_id: customer.id).destroy_all
        ResultQuiz.where(customer_id: customer.id).destroy_all
        cookies[:customer_id] = customer.id
      end
    else
      render json: { status: "not_found", message: "E-mail não encontrado. Você pode iniciar o questionário." }
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :email, :phone, :company_name, :cnpj)
  end
end
