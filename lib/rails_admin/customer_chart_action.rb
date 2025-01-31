# lib/rails_admin/customer_chart_action.rb
module RailsAdmin
  module Config
    module Actions
      class CustomerChart < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self) # Registro da ação

        register_instance_option :member do
          true
        end

        register_instance_option :collection do
          false
        end

        register_instance_option :visible? do
          authorized? # Apenas se o usuário tiver permissão
        end

        register_instance_option :link_icon do
          'fa fa-bar-chart' # Ícone do gráfico
        end

        register_instance_option :controller do
          Proc.new do
            # Aqui você pode definir a lógica da sua ação
            @customer = Customer.find(params[:id])
            @axi_ids = Axi.order(:id).pluck(:id)
            flash[:notice] = "Exibindo gráfico para o Cliente #{@customer.id}"
            # redirect_to back_or_index
            render "rails_admin/main/custom_page"
          end
        end

        register_instance_option :link_icon do
          'fa fa-bar-chart'
        end
      end
    end
  end
end
