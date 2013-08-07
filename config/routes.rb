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
    resources :markets do
      resources :payloads
    end
    resources :courses
    resources :sections
    resources :lectures do
      resources :payloads
    end

    resources :articles

    resources :users
    resources :goals
    resources :categories
    resources :polls
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
  resources :goals, :only => [:index, :show] do
    member do
      post :share
      post :checkin
    end
  end


  namespace :ajax do
    resources :comments, :only => [:create, :update, :destroy], :defaults => {:format => :json}
    resources :users, :only => [:update], :defaults => {:format => :json}
    resources :goals, :only => [:index], :defaults => {:format => :json}
    resources :categories, :only => [:index], :defaults => {:format => :json}
    resources :checkins, :only => [:index, :show], :defaults => {:format => :json} do
      collection do
        get 'add_checkin' => 'checkins#add_checkin'
      end
    end
    resources :goal_users, :only => [], :defaults => {:format => :json} do
      collection do
        post 'set_privacy' => 'goal_users#set_privacy'
      end
    end
    resources :votes, :only => [], :defaults => {:format => :json} do
      collection do
        post 'up_vote' => 'votes#up_vote'
        post 'down_vote' => 'votes#down_vote'
        post 'un_vote' => 'votes#un_vote'
      end

    end
    resources :poll_results, :only => [:create, :destroy], :defaults => {:format => :json}
    resources :poll_questions, :only => [:show], :defaults => {:format => :json}
  end


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
    constraints(:id => /[0-9A-Za-z\-\.\_]+/) do
      get ':id' => 'users#profile', :as => :user
      get ':id/edit' => 'users/registrations#edit', :as => :user_edit
      get ':id/course' => 'users#course', :as => :user_course

      # Signup flow
      get ':id/welcome' => 'users#welcome', :as => :user_welcome
      post ':id/welcome' => 'users#welcome_save', :as => :user_welcome
      # Signup flow

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
