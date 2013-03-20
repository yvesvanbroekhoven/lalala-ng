Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  get  '/lalala/markdown/cheatsheet', to: 'lalala/markdown#cheatsheet'

  match '/404', to: 'errors#not_found'
  match '/422', to: 'errors#unprocessable_entity'
  match '/500', to: 'errors#internal_server_error'

  get '/*path', to: 'pages#show'
  root to: 'pages#show'

end
