Rails.application.routes.draw do
  namespace :users do
    get 'omniauth_callbacks/github'
    get 'omniauth_callbacks/vkontakte'
    get 'omniauth_callbacks/twitter'
    get 'omniauth_callbacks/facebook'
  end
  devise_for :users

  get '/:locale' => 'welcome#index'
  scope "(:locale)", locale: /en|ru/ do
    get '/user/:id' => 'users#show', as: 'user'
    get '/users' => 'users#index'
    root 'welcome#index'
  end
end
