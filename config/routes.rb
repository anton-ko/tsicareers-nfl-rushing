Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :rushings, only: [:index] do
    collection do
      get "export"
    end
  end
end
