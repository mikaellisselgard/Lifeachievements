Rails.application.routes.draw do
  resources :comments
  
  devise_for :users
  resources :posts do
    put 'report_post', to: 'posts#report_post'
  end
  resources :achievements do
    get :autocomplete_achievement_description, :on => :collection
  end
  resources :categories
  resources :users do
    get :autocomplete_user_name, :on => :collection
    put 'follow', to: 'users#follow'
    put 'unfollow', to: 'users#unfollow'
    post 'noticed', to: 'users#noticed'
    post 'tip', to: 'users#tip'
  end
  
  put 'bucket_list/add_bucket_list_item/:id', to: 'bucket_lists#add_bucket_list_item', as: 'add_bucket_list_item'
  delete 'bucket_list/remove_bucket_list_item/:id', to: 'bucket_lists#remove_bucket_list_item', as: 'remove_bucket_list_item'
  put 'posts/like/:id', to: 'posts#like_post', as: 'like_post'
  get 'highscore', to: 'home#highscore'
  post 'comments' => 'comments#create', defaults: { format: 'js' }
  get 'friends', to: 'posts#follow_index', as: 'follow_posts'
  get 'join', to: 'home#join'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'posts#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
