module RailsAdmin
  class CustomController < RailsAdmin::ApplicationController
    def customer_chart
      # Recupera o ID do cliente da URL
      customer_id = params[:customer_id]

      # Busca os dados do cliente (ou respostas, etc.)
      @customer = Customer.find(customer_id)
      @axi_ids = Axi.order(:id).pluck(:id)

      @data = {
        labels: ['Janeiro', 'Fevereiro', 'Março'],
        values: [10, 20, 30] # Substitua por dados reais do cliente
      }

      # Renderiza a view personalizada
      render 'rails_admin/main/customer_chart'
    end
  end
end
