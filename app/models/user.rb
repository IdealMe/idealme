require 'active_support/core_ext/string/inflections'
class User < ActiveRecord::Base
  acts_as_taggable_on :interests

  # == Imports ==============================================================
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :omniauthable, :confirmable

  # == Slug =================================================================
  def to_param
    username
  end

  # == Constants ============================================================

  # == Attributes ===========================================================
  attr_accessor :login

  # == Relationships ========================================================
  has_many :subscriptions
  has_many :owned_courses, class_name: 'Course', foreign_key: 'owner_id'
  has_many :goal_users
  has_many :goals, through: :goal_users

  has_many :saved_jewels
  has_many :jewels, through: :saved_jewels

  has_many :course_users
  has_many :courses, through: :course_users

  has_many :created_jewels, class_name: 'Jewel', foreign_key: 'owner_id'
  has_many :votes, foreign_key: 'owner_id'
  has_many :feedbacks, foreign_key: 'owner_id'
  has_many :checkins, through: :goal_users
  has_many :goal_user_supporters, primary_key: 'id', foreign_key: 'supporter_id'
  has_many :supported_goal_users, through: :goal_user_supporters, source: :goal_user

  has_many :affiliate_sales
  has_many :affiliate_links, dependent: :destroy
  accepts_nested_attributes_for :affiliate_links, allow_destroy: true

  # == Paperclip ============================================================
  has_attached_file :avatar,
                    styles: {thumb: '40x40#', square: '120x120#'},
                    convert_options: {
                        thumb: '-gravity center -extent 40x40 -quality 75 -strip',
                        square: '-gravity center -extent 120x120 -quality 75 -strip',
                    }

  # == Validations ==========================================================
  validates :username, presence: true
  validates :email, presence: true

  validates :username, uniqueness: true
  validates :email, uniqueness: true

  validate :allowed_username

  after_create -> {
    return unless Rails.env.production?
    NewUserNotification.perform_in(10.seconds, self.id)
  }

  # == Scopes ===============================================================
  scope :get_affiliate_user, lambda { |code| where(affiliate_tag: code, access_affiliate: true) }

  # == Callbacks ============================================================
  before_validation :set_username, :reject_blank_affiliate_links
  after_create :after_create

  # == Class Methods ========================================================

  # Generates an unique username for the user, expects two seeds, firstname and lastname
  #
  # Generates in the fashion firstname.lastname if available, otherwise will append numbers in the format firstname.lastname.###
  # @param [String] firstname_seed the firstname seed
  # @param [String] lastname_seed the lastname seed
  # @return [String] an unique username for the user
  def self.generate_unique_username(firstname_seed, lastname_seed)
    firstname = Time.now.to_i.to_s
    firstname = (firstname_seed.gsub(/[^[:alnum:]]/, '').gsub(' ', '').downcase) if firstname_seed

    lastname = Time.now.to_i.to_s
    lastname = (lastname_seed.gsub(/[^[:alnum:]]/, '').gsub(' ', '').downcase) if lastname_seed

    original = "#{firstname}.#{lastname}"
    user = User.where(username: original).first
    return original if user.nil?
    original = "#{firstname}.#{lastname}."
    # we only want lowercase alphanumeric in the seed
    username = original
    counter = 0
    # Find a unused username
    while User.where(username: username).first
      username = original + counter.to_s
      counter += 1
    end
    username
  end

  # Finds or creates an identity based on the given parameters
  #
  # @param [Symbol] provider one of *:facebook*, or *:google_oauth2*
  # @param [Hash] omniauth a hash of omniauth oauth data
  # @param [User] target_user the currently logged in user or nil if no user is logged in
  # @return [Hash] a hash with following keys:
  #  *:identity*: the identity for the provider,
  #  *:user*: the user from the provider,
  #  *:result* the result from the method.
  #  when *:result* is *0* then there is an exception
  def self.find_or_create_identity(provider, omniauth, target_user)
    result = Hash.new
    identity = Identity.where(provider: omniauth.provider, uid: omniauth.uid).includes(:owner).first
    # Logged in user with new identity
    if target_user && identity.nil?
      identity = Identity.create!(identifier: omniauth.uid, provider: omniauth.provider, access_token: omniauth.credentials.to_json, uid: omniauth.uid, owner_id: target_user.id)
      result = {identity: identity, user: identity.owner, result: 1}
      # Anonymous user with authenticated identity
    elsif target_user.nil? && identity
      result = {identity: identity, user: identity.owner, result: 1}
      # Anonymous user with new identity, and an email is provided
    elsif target_user.nil? && identity.nil? && omniauth.info.email
      user = User.where(email: omniauth.info.email).first
      if user.nil?
        # When provider is facebook
        if provider == :facebook
          file = open("http://graph.facebook.com/#{omniauth.uid}/picture?type=large")
          # When provider is Google OAuth
        elsif provider == :google_oauth2
          file = open(omniauth.info.image) if omniauth.info.image
        end
        user = User.new(firstname: omniauth.info.first_name, lastname: omniauth.info.last_name, username: User.generate_unique_username(omniauth.info.first_name, omniauth.info.last_name), email: omniauth.info.email, password: Devise.friendly_token[0, 20])
        #user.assign_attributes({has_password: false}, as: :internal)
        user.avatar = file if file
        user.save!
        identity = Identity.create!(identifier: omniauth.uid, provider: omniauth.provider, access_token: omniauth.credentials.to_json, uid: omniauth.uid, owner_id: user.id)
        result = {identity: identity, user: identity.owner, result: 1}
      else
        # Anonymous user tried to attach an identity to an existing account
        result[:result] = 0
      end
    else
      # This can not happen...
      result[:result] = 0
    end
    result
  end

  def self.for_select
    User.all.collect { |user| [user.fullname, user.id] }
  end

  # == Instance Methods =====================================================

  def drip_articles
    # articles that the user can see based on the duration of their subscription, if any
    sub = self.subscriptions.first
    @articles = []

    if self.access_admin?
      @articles = Article
        .where(drip_content: true).to_a
    elsif sub
      @articles = Article
        .where(drip_content: true)
        .where("reveal_after_days <= ?", sub.subscribed_days).to_a
    end
  end


  def fullname
    "#{self.firstname} #{self.lastname}"
  end

  def fullname_or_username_or_id
    "#{((fullname.present? ? fullname : nil) || (username.present? ? username : nil) || id)}"
  end

  # After create callback
  #
  # The callback will set the user's profile pic to a random avatar if one was not provided
  def after_create
    if self.avatar_file_name.nil? && !Rails.env.test?
      avatars = Dir.glob("#{Rails.root.to_s}/db/seeds/users/avatars/anon*.png")
      self.avatar = File.new(avatars.sample, 'r')
      self.save!
    end

    # send welcome email?
    # add to aweber
    #self.add_to_aweber!
  end

  def unsubscribe_goal(goal)
    GoalUser.where(user_id: self.id, goal_id: goal.id).first.try :destroy
  end

  def subscribe_goal(goal)
    c = GoalUser.where(user_id: self.id, goal_id: goal.id).first
    if c.nil?
      c = GoalUser.create(user_id: self.id, goal_id: goal.id)
    end
    c
  end

  def subscribe_course(course)
    c = CourseUser.where(user_id: self.id, course_id: course.id).first
    if c.nil?
      c = CourseUser.create(user_id: self.id, course_id: course.id)
      # CourseMailer.delay.course_registration_confirmation(self, course)
    end
    c
  end

  def voted?(poll)
    PollResult.where(owner_id: self.id, poll_question_id: poll.id).exists?
  end

  def can_vote?(poll)
    PollResult.where(owner_id: self.id, poll_question_id: poll.id).exists?
  end

  def subscribed_course?(course)
    CourseUser.where(user_id: self.id, course_id: course.id).exists?
  end

  def subscribed_section?(section)
    subscribe_course(section.course)
  end

  def subscribed_lecture?(lecture)
    subscribe_course(lecture.course)
  end

  def instructor_about
    self.read_attribute(:instructor_about) || ""
  end

  def reject_blank_affiliate_links
    self.affiliate_links = affiliate_links.reject do |link|
      link.market_tag.blank? && link.slug.blank?
    end
  end

  def set_username
    if username.nil? && email.present?
      self.username = email.split('@').first.parameterize('-')
      self.username = "#{SecureRandom.urlsafe_base64(5)}_#{self.username}" unless self.valid?
    end
  end

  # new function to set the password without knowing the current password used in our confirmation controller.
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  # new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

  def password_required?
    # Password is required if it is being set, but not for new records
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

  def aweber
    if @aweber
      @aweber
    else
      require 'aweber'
      oauth = AWeber::OAuth.new(ENV['AWEBER_CONSUMER_KEY'], ENV['AWEBER_CONSUMER_SECRET'])
      #Rather than authorizing with the verification code, we use the token and secret
      oauth.authorize_with_access(ENV['AWEBER_TOKEN'], ENV['AWEBER_SECRET'])
      @aweber = AWeber::Base.new(oauth)
    end
  end

  def add_to_aweber!
    return unless Rails.env.production?
    list = aweber.account.lists.find_by_name('idealmeoptin')
    subscriber = {"email" => self.email}
    list.subscribers.create(subscriber)
    self.update_attribute :added_to_aweber, true
  rescue AWeber::CreationError => e
    Rails.logger.info "Failed to add #{self.email} to aweber mailing list"
  end

  def allowed_username
    path = Rails.application.routes.recognize_path "/#{self.username}"
    unless path[:controller] == "users" &&
       path[:action] == "profile"
      errors.add(:username, "not allowed")
    end
  end

end

