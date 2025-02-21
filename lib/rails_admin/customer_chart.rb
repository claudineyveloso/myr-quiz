# lib/rails_admin/customer_chart.rb
puts "###############################################"
puts "Carregando customer_chart.rb"
puts "###############################################"

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
            customer = Customer.find(params[:id])
            total_average_score = 0
            @results = []
            @messages = []
            @axis_environmental = []
            @axis_social = []
            @axis_governance = []
            @customer = []


            color_codes = {
              1 => "#F1F2D4",
              2 => "#D6F0F2",
              3 => "#E6CBE3"
            }

            @axi_ids = Axi.order(:id).pluck(:id)
            @axi_ids.each do |axi_id|
              results_for_axi = ResultQuiz.by_axi_customer(axi_id, customer.id)
              @customer = results_for_axi
              first_result = results_for_axi[0]
              puts first_result.average_score.to_f
              total_average_score += first_result.average_score.to_f

              @results << {
                axi_id: axi_id,
                results: {average_score: format("%.2f", first_result.average_score), id: first_result.id, axi_name: first_result.axi.name}
              }

              themes_for_axi = Answer.by_axis_by_customer(axi_id, customer.id)
              themes_for_axi.each do |theme|
                case axi_id
                when 1
                  @axis_environmental << {theme_id: theme.id, theme_name: theme.theme.name, average_score: format("%.2f", theme.maturity_value)}
                when 2
                  @axis_social << {theme_id: theme.id, theme_name: theme.theme.name, average_score: format("%.2f", theme.maturity_value)}
                when 3
                  @axis_governance << {theme_id: theme.id, theme_name: theme.theme.name, average_score: format("%.2f", theme.maturity_value)}
                end
              end
              puts "###############################################################"
              puts "axis_environmental: #{@axis_environmental}"
              puts "axis_social: #{@axis_social}"
              puts "axis_governance: #{@axis_governance}"
              puts "###############################################################"

              maturity_messages = MaturityMessage.joins(:axi, :maturity)
                .where(axi_id: first_result.axi_id, maturity_id: first_result.maturity_id)
              maturity_messages.each do |message|
                @messages << {
                  message: message,
                  color_code: color_codes[axi_id] # Define a cor com base no axi_id
                }
              end
            end
            average_score = (total_average_score / 3 * 10).floor / 10.0

            maturity = Maturity.find_by("range_initial <= ? AND range_final >= ?", average_score, average_score)
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
