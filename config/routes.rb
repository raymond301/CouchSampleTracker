CouchSampleTracker::Application.routes.draw do
  resources :bug_traxes

  resources :mayo_submissions

  resources :validations

  resources :samples
  get "samples/multi_edit"
  post "samples/multi_update" => 'samples#multi_update'

  resources :projects
  get "projects/count/:id" => 'projects#count'


  get "dashboard/index"
  post "dashboard/find_sample" => 'dashboard#find_sample'
  get "dashboard/search"
  get "dashboard/view_studygrps"
  get "dashboard/edit_studygrps"
  patch "dashboard/updategrp" => 'dashboard#updategrp'


  get "carrier/new"
  get "carrier/notifications"
  post "carrier/create_source" => 'carrier#create_source'
  post "carrier/create_submission" => 'carrier#create_submission'
  get "carrier/ggps_config_new"
  post "carrier/ggps_config_create" => 'carrier#ggps_config_create'




  # You can have the root of your site routed with "root"
  root :to => 'dashboard#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
