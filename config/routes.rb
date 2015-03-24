Rails.application.routes.draw do
  root to: 'terms#index'
  resources :terms, only: [:index, :show, :create] do
    get :radial, on: :member
  end
end
