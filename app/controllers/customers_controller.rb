class CustomersController < ApplicationController

  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @customer = Customer.new # Inicializa um novo objeto Customer
  end

  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      # Redireciona para a ação 'index' ou outra página de sua escolha
      redirect_to customers_path, notice: 'Cliente criado com sucesso.'
    else
      # Renderiza a nova página de formulário se houver erros
      render :new
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :email, :phone, :company_name, :cnpj)
  end

end
