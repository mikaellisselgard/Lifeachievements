Rails.application.routes.draw do
  get 'home/index'

  devise_for :users
  resources :bucket_lists
  resources :posts
  resources :achievements do
    get :autocomplete_achievement_description, :on => :collection
  end
  resources :categories
  resources :users do
    get :autocomplete_user_name, :on => :collection
  end
  
  post 'bucket_list/add_achievement/:id', to: 'bucket_lists#add_achievement', :as => 'add_achievement_bucket_list'
  put 'bucket_list/remove_achievement/:id', to: 'bucket_lists#remove_achievement', :as => 'update_bucket_list'
  patch 'bucket_list/remove_achievement/:id', to: 'bucket_lists#remove_achievement', :as => 'update_bucket_list'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

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
