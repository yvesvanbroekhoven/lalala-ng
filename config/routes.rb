Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  get  '/lalala/markdown/cheatsheet', to: 'lalala/markdown#cheatsheet'

end
