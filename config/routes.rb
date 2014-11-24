Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  namespace :redactor do
    resources :pictures, :only => [:index, :create]
  end

  unless Rails.env.production?
    get "master_login" => "pages#master_login"
  end

  get '/' => 'pages#temporary'
  get '/temp_root' => 'pages#home', as: :root

  # root 'pages#home'
  # get 'pages/temporary' => 'pages#temporary'

  resources :contents do
    get 'search', on: :collection
    get 'tags', on: :collection
  end

  resources :videos do
    get 'download'
  end
  resources :audios do
    get 'download'
  end
  resources :images do
    get 'download'
  end
  resources :remixes do
    get 'download'
  end
  resources :warnings
  resources :posts

  resources :pages do
    post :change_user_session
  end


  namespace :admin do
    resources :users
    resources :posts
    resources :warnings
    resources :videos  do
      put 'toggle_main'
      put 'toggle_open'
      get 'remote_videos', on: :collection
      post 'fetch_selected_remote_videos', on: :collection
      post 'fetch_remote_video', on: :collection
    end
    resources :audios  do
      get 'remote_audios', on: :collection
      post 'fetch_selected_remote_audios', on: :collection
      post 'fetch_remote_audio', on: :collection
      put 'toggle_main'
      put 'toggle_open'
    end
    resources :images  do
      get 'remote_images', on: :collection
      post 'fetch_selected_remote_images', on: :collection
      post 'fetch_remote_image', on: :collection
      put 'toggle_main'
      put 'toggle_open'
    end
    resources :contents
    resources :categories
    root 'videos#index'
  end
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
