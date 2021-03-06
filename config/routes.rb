Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  # devise_for :admin_users, {class_name: 'User'}.merge(ActiveAdmin::Devise.config)

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    resources :users
    resources :post_categories, path: 'categories'
    get 'adv/moderate', to: 'posts#moderate', as: 'moderate'
    post 'adv/action', to: 'posts#action'
    post 'adv/new/image/:operation', to: 'posts#new_post_image', as: 'new_post_image'
    resources :posts, path: 'adv'
    scope '/adv/:id', as: 'post' do
      post 'run', to: 'posts#run', as: 'run'
      post 'draft', to: 'posts#draft', as: 'draft'
      post 'reject', to: 'posts#reject', as: 'reject'
      post 'ban', to: 'posts#ban', as: 'ban'
      post 'approve', to: 'posts#approve', as: 'approve'
      post 'archive', to: 'posts#archive', as: 'archive'
      post 'publish', to: 'posts#publish', as: 'publish'
      post 'image/:operation', to: 'posts#image', as: 'image'
    end
    get 'tags/search', to: 'tags#search'
    get 'tags/:tag', to: 'tags#index', as: :tag
    root 'welcome#index'
  end
end
