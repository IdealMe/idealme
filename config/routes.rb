Idealme::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  get "pictures" => "ckeditor/pictures#index"
  post "pictures" => "ckeditor/pictures#create"

  get "screenshots/index" unless Rails.env.production?
  get "screenshots/reset" unless Rails.env.production?

  get "payload/:id/download" => "payload#download", as: :download_payload

  get "/ic/article/:slug" => "users#drip_content_article", as: :drip_content_article

  root to: 'landings#index'
  get 'ideal-life' => 'landings#index'
  get 'ideallife' => 'landings#hit_your_goals'
  get '__ping' => 'landings#ping'
  get 'aweber_callback' => 'landings#aweber_callback'
  get 'workbook' => 'landings#workbook'
  get 'hit-your-goals' => 'landings#hit_your_goals'
  get 'action-sidekick' => 'landings#action_sidekick'
  get 'continuity-offer-1' => 'landings#continuity_offer_1'
  get 'continuity-offer-2' => 'landings#continuity_offer_2'

  get 'thanks/:thanks_type' => 'landings#thanks'
  post 'purchase-continuity-offer' => 'landings#purchase_continuity_offer', as: :purchase_continuity_offer
  post 'purchase-action-sidekick' => 'landings#purchase_action_sidekick', as: :purchase_action_sidekick

  get 'download-workbook' => 'resources#download_workbook'

  get "now/:slug(/:market_tag)" => "affiliate_links#perform", slug: /[^\/]+/, as: :affiliate_link

  resources :searches, only: [:index]
  resources :lectures, only: [:index, :show]
  resources :feedbacks, only: [:index, :new, :create]
  resources :orders, only: [:new, :create] do
    collection do
      get 'new/action-sidekick' => 'orders#new_action_sidekick', as: :order_action_sidekick
      get 'new/workbook' => 'orders#new_workbook', as: :order_workbook
      get 'new/subscription' => 'orders#new_subscription', as: :order_subscription
      post 'create/workbook-order' => 'orders#create_workbook_order', as: :create_workbook_order
      post 'create/subscription-order' => 'orders#create_subscription_order', as: :create_subscription_order
      post 'create/action-sidekick-order' => 'orders#create_action_sidekick_order', as: :create_action_sidekick_order
      get 'new/:id' => 'orders#new', as: :subscribe
    end
  end

  resources :markets, only: [:index, :show] do
    collection do
      get ':market_affiliate_tag/:user_affiliate_tag/:tracking_affiliate_tag' => 'markets#affiliate_init', as: :markets_affiliate_tracking, user_affiliate_tag: /[^\/]+/
      get ':market_affiliate_tag/:user_affiliate_tag' => 'markets#affiliate_init', as: :markets_affiliate, user_affiliate_tag: /[^\/]+/
    end
  end

  resources :courses, only: [:index, :show] do
    resources :reviews
  end
  resources :discovers, only: [:index, :show]
  resources :resources do
    collection do
      get "my-goals" => :my_goals, as: :my_goals
      get "goal/:goal_id" => :goal, as: :goal
    end
  end
  resources :goals, only: [:index, :show] do
    resources :gems, controller: :jewels do
      member do
        put "" => 'jewels#update'
        get :comments
        get :modal_content
        post :save
      end
    end
    member do
      get ':tab' => 'goals#show', constraints: {tab: /(activity)|(top-gem)|(my-gem)|(course)/}, as: :tab
      post :share
      post :checkin
      post :activate
      post :complete
      post :archive
      post :toggle
      get 'filter/:filter_name' => 'goals#filter', as: :filter
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

    resources :fragments

    resources :courses do
      member do
        post :sort_sections
        post :update
      end
    end
    resources :sections do
      collection do
        post :sort
      end
    end
    constraints(id: /[^\/]+/) do
      resources :users
      get 'users/:id/edit' => "users#edit", id: /[^\/]+/
    end
    resources :orders
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
    constraints(id: /[0-9A-Za-z\-\.\_]+/) do
      resources :users, only: [:update], defaults: {format: :json}
    end
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
        post 'set_order' => 'goal_users#set_order'
        post 'toggle_goal' => 'goal_users#toggle_goal'
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
    post 'sendgrid/notify' => 'send_grid#notify'
    post 'stripe/notify' => 'stripe#notify'
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

  as :user do
    patch '/users/confirmation' => 'users/confirmations#update', :via => :patch, :as => :update_user_confirmation
  end

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
          get 'user/sidekick' => 'users#sidekick', as: :sidekick

          get ':id/sdfsdf/:tab' => 'users#profile', constraints: {tab: /(goal)|(course)|(saved-course)/}, as: :user_tab

          get ':id/edit' => 'users/registrations#edit', as: :user_edit
          get ':id/edit_password' => 'users/registrations#edit_password', as: :user_edit_password

          # Signup flow
          #get ':id/welcome' => 'users#welcome', as: :user_welcome
          get 'user/welcome' => 'users#welcome', as: :user_welcome
          post 'user/welcome' => 'users#welcome_save'
          post 'user/dismiss-welcome-message' => 'users#dismiss_welcome_message'
          # Signup flow


          get ':id/friend' => 'users#friend', as: :user_friend
          get ':id/stuff' => 'users#stuff', as: :user_stuff
          get ':id/feed' => 'users#feed', as: :user_feed
          get ':id/notification' => 'users#notification', as: :user_notification
          get ':id/identity' => 'users#identity', as: :user_identity
          get ':id/identity/:pid/revoke' => 'users#identity_revoke', as: :user_identity_revoke
        end
      end
      comfy_route :cms_admin, :path => '/admin/cms'
      comfy_route :cms, :path => '/static', :sitemap => false
end
