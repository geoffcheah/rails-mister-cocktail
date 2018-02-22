Rails.application.routes.draw do
  resources :cocktails, only: [:index, :show, :new, :create]

  root to: 'cocktails#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
