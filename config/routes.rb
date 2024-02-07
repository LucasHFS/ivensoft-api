Rails.application.routes.draw do
  scope '/api', defaults: { format: :json } do
    devise_for :users, defaults: { format: :json }, path_names: { sign_in: :login }, controllers: { sessions: :sessions, registrations: :registrations }
    resource :organizations, only: %i[create show]
    resource :user, only: %i[show]
  end
end
