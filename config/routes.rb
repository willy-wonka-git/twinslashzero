Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  namespace :users do
    get 'omniauth_callbacks/vkontakte'
    get 'omniauth_callbacks/twitter'
    # get 'omniauth_callbacks/github'
    # get 'omniauth_callbacks/facebook'
  end

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    get '/user/:id' => 'users#show', as: 'user'
    get '/users' => 'users#index'
    resources :post_categories, path: 'categories'

    get 'adv/moderate', to: 'posts#moderate', as: 'moderate'
    post 'adv/action', to: 'posts#action'
    resources :posts, path: 'adv'
    scope '/adv/:id', as: 'post' do
      post 'run', to: 'posts#run', as: 'run'
      post 'draft', to: 'posts#draft', as: 'draft'
      post 'reject', to: 'posts#reject', as: 'reject'
      post 'ban', to: 'posts#ban', as: 'ban'
      post 'approve', to: 'posts#approve', as: 'approve'
      post 'archive', to: 'posts#archive', as: 'archive'
      post 'publish', to: 'posts#publish', as: 'publish'
    end

    get 'tags/search', to: 'tags#search'
    get 'tags/:tag', to: 'posts#index', as: :tag
    root 'welcome#index'
  end
end
