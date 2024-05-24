Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  get '/current_user', to: 'current_user#index'

  scope :api do
    scope :v1 do
      resources :users, param: :username
      resources :applications, param: :token do
        resources :chats, param: :number do
          resources :messages, param: :number do
            get 'search', to: 'messages#search', on: :collection
          end
        end
      end
    end
  end
end
