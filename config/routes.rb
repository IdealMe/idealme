Idealme::Application.routes.draw do
  resources :lectures

  resources :orders, :only => [:new, :create] do
    collection do
      get 'new/:id' => 'orders#new', :as => :subscribe
    end
  end
  root :to => 'landings#index'
  namespace :admin do
    root :to => 'landings#index'
    resources :markets
    resources :courses
    resources :sections
    resources :lectures
    resources :users
    resources :goals
  end

  resources :markets, :only => [:index, :show] do
    resources :reviews
    collection do
      get ':market_affiliate_tag/:user_affiliate_tag/:tracking_affiliate_tag' => 'markets#affiliate_init', :as => :markets_affiliate_tracking
      get ':market_affiliate_tag/:user_affiliate_tag' => 'markets#affiliate_init', :as => :markets_affiliate
    end
  end

  resources :courses, :only => [:index, :show]
  resources :discovers, :only => [:index, :show]

  ComfortableMexicanSofa::Routing.admin(:path => '/cms-admin')
  # Make sure this routeset is defined last
  ComfortableMexicanSofa::Routing.content(:path => '/cms', :sitemap => false)

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
      get ':id/welcome' => 'users#welcome', :as => :user_welcome
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

end
