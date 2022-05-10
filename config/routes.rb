Rails.application.routes.draw do
  devise_for :users
  root 'expenses#index'
  
  resources :expenses do
    post 'export', on: :collection
  end
end
