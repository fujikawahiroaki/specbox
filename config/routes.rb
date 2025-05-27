Rails.application.routes.draw do
  root "dashboard#index"
  resources :tours do
    collection do
      patch :bulk_update
      delete :bulk_delete
      get :search
    end
  end
  resources :specimens
  resources :specimen_labels
  resources :custom_taxa
  resources :default_taxa
  resources :collection_settings do
    collection do
      patch :bulk_update
      delete :bulk_delete
    end
  end
  resources :collect_points do
    collection do
      patch :bulk_update
      delete :bulk_delete
      get :reverse_zipcode
      get :export_csv
      get :export_csv_excel
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  # auth0
  get "/auth/auth0/callback" => "auth0#callback"
  get "/auth/failure" => "auth0#failure"
  get "/auth/logout" => "auth0#logout"
end
