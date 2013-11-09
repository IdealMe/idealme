Idealme::Application.routes.draw do

  get "payload/:id/download" => "payload#download", as: :download_payload

  root to: 'landings#index'

  match "now/:slug" => "affiliate_links#perform", slug: /[^\/]+/

  resources :searches, only: [:index]
  resources :lectures, only: [:index, :show]
  resources :feedbacks, only: [:index, :new, :create]
  resources :orders, only: [:new, :create] do
    collection do
      get 'new/:id' => 'orders#new', as: :subscribe
      post 'thanks/:id' => 'orders#thanks', as: :paypal_return
    end
    member do
      post 'paypal' => 'orders#paypal_checkout', as: :paypal_checkout
      get 'paypal-return' => 'orders#paypal_return'
      get 'paypal-cancel' => 'orders#paypal_cancel'
    end
  end

  match "paypal/success" => "paypal#success"
  match "paypal/cancel" => "paypal#cancel"

  resources :markets, only: [:index, :show] do
    resources :reviews
    collection do
      get ':market_affiliate_tag/:user_affiliate_tag/:tracking_affiliate_tag' => 'markets#affiliate_init', as: :markets_affiliate_tracking, user_affiliate_tag: /[^\/]+/
      get ':market_affiliate_tag/:user_affiliate_tag' => 'markets#affiliate_init', as: :markets_affiliate, user_affiliate_tag: /[^\/]+/
    end
  end
  resources :courses, only: [:index, :show]
  resources :discovers, only: [:index, :show]
  resources :goals, only: [:index, :show] do
    member do
      get ':tab' => 'goals#show', constraints: {tab: /(activity)|(top-gem)|(my-gem)|(course)/}, as: :tab
      post :share
      post :checkin
      post :activate
      post :complete
      post :archive
    end
    collection do
      get :archived
      post '' => 'goals#choose'
    end
  end

  namespace :admin do
    root to: 'landings#index'
    resources :gems
    resources :markets do
      resources :payloads
    end
    resources :lectures do
      get 'payloads_partial' => 'lectures#payloads_partial'
      post 'attach_payload' => 'lectures#attach_payload'
      resources :payloads do
        member do
          put :remove
        end
      end
      collection do
        post :sort
      end
    end
    resources :articles do
      resources :payloads
    end

    resources :courses do
      member do
        post :sort_sections
      end
    end
    resources :sections do
      collection do
        post :sort
      end
    end
    resources :users
    get 'users/:id/edit' => "users#edit", id: /[^\/]+/
    resources :goals
    resources :categories
    resources :polls
    resources :feedbacks
  end

  namespace :dashboard do
    root :to => 'landings#index'
    resources :swipes, :only => [:index, :show]
    resources :affiliates
    resources :redirections
    resources :payments
    resources :courses do
      resources :upsells
      member do
        post 'add_student'
      end
    end
  end


  namespace :ajax do
    resources :comments, only: [:create, :update, :destroy], defaults: {format: :json}
    resources :users, only: [:update], defaults: {format: :json}
    resources :goals, only: [:index], defaults: {format: :json}
    resources :categories, only: [:index], defaults: {format: :json}
    resources :checkins, only: [:index, :show], defaults: {format: :json} do
      collection do
        get 'add_checkin' => 'checkins#add_checkin'
      end
    end
    resources :goal_users, only: [], defaults: {format: :json} do
      collection do
        post 'set_privacy' => 'goal_users#set_privacy'
      end
    end
    resources :votes, only: [], defaults: {format: :json} do
      collection do
        post 'up_vote' => 'votes#up_vote'
        post 'down_vote' => 'votes#down_vote'
        post 'un_vote' => 'votes#un_vote'
      end
    end
    resources :poll_results, only: [:create, :destroy], defaults: {format: :json}
    resources :poll_questions, only: [:show], defaults: {format: :json}
  end


  namespace :webhook do
    resources :paypals, only: [] do
      collection do
        post 'paypal_return' => 'paypals#paypal_return'
        post 'paypal_cancel' => 'paypals#paypal_cancel'
        post 'paypal_create' => 'paypals#paypal_create'

        get 'paypal_return' => 'paypals#paypal_return'
        get 'paypal_cancel' => 'paypals#paypal_cancel'
      end

    end
  end

  ComfortableMexicanSofa::Routing.admin(path: '/admin/cms')
  # Make sure this routeset is defined last
  ComfortableMexicanSofa::Routing.content(path: '/static', sitemap: false)

  devise_for :users,
             path: '',
             path_names: {
                 sign_in: 'login',
                 sign_out: 'logout',
                 password: 'forgot_password',
                 confirmation: 'verification',
                 unlock: 'unblock',
                 registration: 'register',
                 sign_up: 'sign_up'},
             controllers: {
                 omniauth_callbacks: 'users/omniauth_callbacks',
                 confirmations: 'users/confirmations',
                 passwords: 'users/passwords',
                 registrations: 'users/registrations',
                 sessions: 'users/sessions',
                 unlocks: 'users/unlocks',
                 invitations: 'users/invitations'}
  devise_scope :user do
    get 'users/auth/:provider' => 'users/omniauth_callbacks#passthru'
    get 'register/affiliate_sign_up' => 'users/registrations#new_affiliate', as: :new_affiliate_registration
    post 'register/affiliate_sign_up' => 'users/registrations#create_affiliate', as: :affiliate_registration
    constraints(id: /[0-9A-Za-z\-\.\_]+/) do
      get ':id' => 'users#profile', as: :user

      get ':id/sdfsdf/:tab' => 'users#profile', constraints: {tab: /(goal)|(course)|(saved-course)/}, as: :user_tab

      get ':id/edit' => 'users/registrations#edit', as: :user_edit

      # Signup flow
      get ':id/welcome' => 'users#welcome', as: :user_welcome
      post ':id/welcome' => 'users#welcome_save', as: :user_welcome
      # Signup flow


      get ':id/friend' => 'users#friend', as: :user_friend
      get ':id/stuff' => 'users#stuff', as: :user_stuff
      get ':id/feed' => 'users#feed', as: :user_feed
      get ':id/notification' => 'users#notification', as: :user_notification
      get ':id/identity' => 'users#identity', as: :user_identity
      get ':id/identity/:pid/revoke' => 'users#identity_revoke', as: :user_identity_revoke
    end
  end

end
