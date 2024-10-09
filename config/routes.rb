Rails.application.routes.draw do
  get "result_quizzes/create"
  get "answers/create"
  devise_for :users
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "/answers", to: redirect("/")

  resources :customers do
    collection do
      get "check_email", to: "customers#check_email"
    end
  end
  resources :answers do
    collection do
      get "start", to: "answers#start"
      get "step/:step", to: "answers#step", as: "step"
      get "axi/:id", to: "answers#axi", as: "axi"
      get "axi_data/:id", to: "answers#axi_data", as: "axi_data"
      get "quiz_by_theme"
    end
  end

  resources :result_quizzes, only: [ :index, :create ]

  # Defines the root path route ("/")
  # root "home#index"
  root "customers#new"
end
