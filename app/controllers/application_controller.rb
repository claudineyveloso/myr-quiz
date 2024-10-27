class ApplicationController < ActionController::Base
  include Rails.application.routes.url_helpers
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :set_show_logos
  before_action :check_logos

  private

  def set_show_logos
    # Pega o domínio (host) da URL
    current_host = request.host.sub(/^www\./, "")

    @test = current_host

    @show_logos = case current_host
    when "esgsolutions.com.br"
      false  # Exibe as logos no domínio esgsolutions.com.br
    when "esgtest.com.br"
      true # Não exibe as logos no domínio esgtest.com.br
    else
      false # Exibe por padrão em outros domínios
    end
  end

  def check_logos
    Rails.logger.info("show_logos: #{@show_logos}")

    # Verifica se o usuário está na página de novo cliente
    if !@show_logos && request.path != new_customer_path
      Rails.logger.info("Redirecting to new_customer_url")
      redirect_to new_customer_url
    end
  end
end
