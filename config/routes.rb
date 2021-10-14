Rails.application.routes.draw do
  namespace :users do
    get 'omniauth_callbacks/github'
    get 'omniauth_callbacks/vkontakte'
    get 'omniauth_callbacks/twitter'
    get 'omniauth_callbacks/facebook'
  end
  devise_for :users
  root 'welcome#index'
end
