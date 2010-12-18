HumanConnections::Application.routes.draw do
  resource :session, :only => [:new, :create, :destroy]
  resource :api, :only => [:create, :destroy]
  resource :home, :only => [:index]

  resources :facebook_accounts, :only => [:show, :destroy, :new] do
    collection do
      get :callback
    end
  end
  
  resources :linked_in_accounts, :only => [:show, :destroy, :new] do
    collection do
      get :callback
    end
  end
  
  resources :twitter_accounts, :only => [:show, :destroy, :new] do
    collection do
      get :callback
    end
  end
  
  match 'home' => 'home#index', :as => :home
  match 'signup' => 'users#new', :as => :signup
  match 'register' => 'users#create', :as => :register
  match 'login' => 'sessions#new', :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'api_login' => 'api#create', :as => :api_login
  match 'api_logout' => 'api#destroy', :as => :api_logout
  match '/activate/:activation_code' => 'users#activate', :as => :activate, :activation_code => nil
  match '/activate/:activation_code' => 'users#activate', :as => :activate, :activation_code => nil
  match 'accounts' => 'accounts#index', :as => :accounts

  resource :users
  resources :email_accounts, :gmail_accounts, :hotmail_accounts, :yahoo_accounts
  resources :phone_accounts, :android_accounts, :iphone_accounts, :blackberry_accounts, :win_mob_accounts

  resource :sessions, :only => [:new, :destroy]

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

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
  # match ':controller(/:action(/:id(.:format)))'
end
