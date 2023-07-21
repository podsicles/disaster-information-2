Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  get "posts" => "posts#index"
  root "posts#index"

  resources :posts do
    resources :comments, except: :show
  end
  resources :categories, except: :show

  namespace :user do
    resources :posts
    resources :comments, except: :show
  end

  namespace :api do
    namespace :v1 do
      resources :regions, only: %i[index show], defaults: { format: :json } do
        resources :provinces, only: :index, defaults: { format: :json }
      end
  
        resources :provinces, only: %i[index show], defaults: { format: :json } do
        resources :cities, only: :index, defaults: { format: :json }
      end
      
      resources :cities, only: %i[index show], defaults: { format: :json } do
        resources :barangays, only: :index, defaults: { format: :json }
      end
      
      resources :barangays, only: %i[index show], defaults: { format: :json }
    end
  end
end
