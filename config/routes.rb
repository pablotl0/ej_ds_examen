# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users do
        collection do
          post :new_user
        end
        
        member do
          post :set_current
        end
        
        resources :accounts, shallow: true do
          resources :transactions, only: [:index] do
            collection do
              post :deposit
              post :withdrawal
              post :transfer
            end
          end
        end
      end
    end
  end
end
