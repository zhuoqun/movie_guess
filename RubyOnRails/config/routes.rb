require ::File.expand_path('../../lib/show_category',  __FILE__)

MovieGuess::Application.routes.draw do

  resources :forgot_passwords, :only => [:new, :create, :edit, :update]

  get "home/index"

  resources :puzzles do
    collection do 
      get :crawl_images
    end

    member do
      get :like
      get :disable
    end

    resources :answers, :only => [:index, :create, :update, :show]

    resources :discussions, :only => [:index, :create, :update, :show]
  end

  resources :answers do
    member do
      get :upvote
      get :downvote
      get :mark_as_correct
      get :cancel_mark_as_correct
    end

    resources :comments, :only => [:index, :create, :update]
  end

  resources :discussions do
    member do
      get :upvote
    end
  end

  resources :accounts, :only => [:create, :update] do
    collection do
      get :signup
      get :login
      get :settings
      get :complete_info
      get :all_users
    end
  end

  get '/logout' => 'sessions#destroy'

  get '/notifications' => 'profiles#notifications'
  get '/unread_notifications' => 'profiles#unread_notifications'

  resources :sessions, :only => [:create]


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  match '/tag/:tag_name' => 'home#tag'

  match '/:category' => 'home#category', :constraints => ShowCategory.new
  match '/fast' => 'fast#index'

  resources :profiles, :only => [:show], :path => '' do
    member do
      get :puzzles
      get :answered
      get :favorites
      get :retweets
      get :followers
      get :follows
      get :follow
      get :unfollow
    end
  end

  match '/accounts/settings/:section' => 'accounts#settings'

  match "/auth/:provider/callback" => "sessions#oauth_success"
  match "/auth/failure" => "sessions#oauth_failure"

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
