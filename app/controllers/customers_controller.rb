class CustomersController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :new, :create, :check_email ]

  def new
    @customer = Customer.new # Inicializa um novo objeto Customer
  end

  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      # Redireciona para a ação 'index' ou outra página de sua escolha
      redirect_to start_answers_path, notice: "Cliente criado com sucesso."
    else
      # Renderiza a nova página de formulário se houver erros
      render :new
    end
  end

  def check_email
    email = params[:email]
    customer_exists = Customer.exists?(email: email)
    render json: { exists: customer_exists }
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :email, :phone, :company_name, :cnpj)
  end
end
