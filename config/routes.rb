Idealme::Application.routes.draw do

  root :to => 'landings#index'

  devise_for :users,
             :path => '',
             :path_names => {
                 :sign_in => 'login',
                 :sign_out => 'logout',
                 :password => 'forgot_password',
                 :confirmation => 'verification',
                 :unlock => 'unblock',
                 :registration => 'register',
                 :sign_up => 'sign_up'},
             :controllers => {
                 :omniauth_callbacks => 'users/omniauth_callbacks',
                 :confirmations => 'users/confirmations',
                 :passwords => 'users/passwords',
                 :registrations => 'users/registrations',
                 :sessions => 'users/sessions',
                 :unlocks => 'users/unlocks',
                 :invitations => 'users/invitations'}
  devise_scope :user do
    get 'users/auth/:provider' => 'users/omniauth_callbacks#passthru'
    get 'register/affiliate_sign_up' => 'users/registrations#new_affiliate', :as => :new_affiliate_registration
    post 'register/affiliate_sign_up' => 'users/registrations#create_affiliate', :as => :affiliate_registration
    constraints(:id => /[0-9A-Za-z\-\.]+/) do
      get ':id' => 'users#profile', :as => :user
      get ':id/edit' => 'users/registrations#edit', :as => :user_edit
      get ':id/course' => 'users#course', :as => :user_course
      get ':id/goal' => 'users#goal', :as => :user_goal
      get ':id/goal/:active_goal' => 'users#active_goal', :as => :user_active_goal
      get ':id/friend' => 'users#friend', :as => :user_friend
      get ':id/stuff' => 'users#stuff', :as => :user_stuff
      get ':id/feed' => 'users#feed', :as => :user_feed
      get ':id/notification' => 'users#notification', :as => :user_notification
      get ':id/identity' => 'users#identity', :as => :user_identity
      get ':id/identity/:pid/revoke' => 'users#identity_revoke', :as => :user_identity_revoke
    end
  end
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
