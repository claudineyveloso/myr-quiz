require Rails.root.join('lib', 'rails_admin', 'customer_chart.rb')
RailsAdmin.config do |config|
  config.asset_source = :importmap

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## Aqui
    # customer_chart do
    #   only ['Customer']  # Disponível APENAS no modelo Customer
    # end
    #
    #
    #
    #
    #
    # Adiciona a ação personalizada
    # customer_chart do
    #   only ['Customer'] # Apenas para o modelo Customer
    # end
    #
    # ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
  config.model 'Customer' do
    list do
      field :id
      field :name
      field :email
      field :phone
      field :cnpj
      field :created_at
      # field :customer_chart do
      #   formatted_value do
      #     bindings[:view].link_to 'Ver Gráfico', bindings[:view].customer_chart_path(model_name: 'customer', id: bindings[:object].id)
      #   end
      # end
    end
  end
end

