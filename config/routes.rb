Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :quotes, only: %i[create show destroy]  # I am skipping update to save time
    end
  end
end
