Rails.application.routes.draw do
  scope '/api', defaults: { format: :json } do
    devise_for :users, defaults: { format: :json }, path_names: { sign_in: :login }, controllers: { sessions: :sessions, registrations: :registrations }
    resource :user, only: %i[show]

    resources :organizations, only: %i[create show]
    resources :categories, only: %i[create index show update destroy]
  end
end
