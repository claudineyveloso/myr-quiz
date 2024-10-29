class ApplicationController < ActionController::Base
  include Rails.application.routes.url_helpers
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :set_show_logos

  private

  def set_show_logos
    # Pega o domínio (host) da URL
    current_host = request.host.sub(/^www\./, "")
    @current_host = current_host
    @show_logos = case current_host
    when "esgsolutions.com.br"
      false  # Exibe as logos no domínio esgsolutions.com.br
    when "esgtest.com.br"
      true # Não exibe as logos no domínio esgtest.com.br
    else
      false # Exibe por padrão em outros domínios
    end
  end
end
