Rails.application.routes.draw do
  scope :api, defaults: { format: :json } do
    devise_for :users, controllers: { sessions: :sessions },
                       path_names: { sign_in: :login }
              
    resource :user, only: [:update, :show]

    resources :books, only: [:index, :update, :create, :destroy]
  end
end
