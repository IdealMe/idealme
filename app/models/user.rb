class User < ActiveRecord::Base
  # == Imports ==============================================================
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :omniauthable, :token_authenticatable

  # == Slug =================================================================
  def to_param
    username
  end

  # == Constants ============================================================

  # == Attributes ===========================================================
  attr_accessible :login, :username, :firstname, :lastname, :email, :password, :password_confirmation,
                  :remember_me, :avatar, :tagline, :affiliate_tag, :instructor_about

  attr_accessible :access_admin, :access_affiliate, :access_instructor, :as => :admin


  attr_accessor :login
  attr_accessible :login

  # == Relationships ========================================================
  has_many :courses

  has_many :goal_users
  has_many :goals, :through => :goal_users

  has_many :created_jewels, :class_name => 'Jewel', :foreign_key => 'owner_id'

  has_many :checkins, :through => :goal_users

  # == Paperclip ============================================================
  has_attached_file :avatar,
                    :styles => {:thumb => '40x40#', :square => '120x120#'},
                    :convert_options => {
                        :thumb => '-gravity center -extent 40x40 -quality 75 -strip',
                        :square => '-gravity center -extent 120x120 -quality 75 -strip',
                    }

  # == Validations ==========================================================
  # == Scopes ===============================================================
  scope :get_affiliate_user, lambda { |code| where(:affiliate_tag => code, :access_affiliate => true) }

  # == Callbacks ============================================================
  after_create :after_create

  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  def fullname
    "#{self.firstname} #{self.lastname}"
  end

  # After create callback
  #
  # The callback will set the user's profile pic to a random avatar if one was not provided
  def after_create
    if self.avatar_file_name.nil?
      avatars = Dir.glob("#{Rails.root.to_s}/db/seeds/users/avatars/*.png")
      self.avatar = File.new(avatars.sample, 'r')
      self.save!
    end
  end

  def subscribe_goal(goal)
    c = GoalUser.where(:user_id => self.id, :goal_id => goal.id).first
    if c.nil?
      c = GoalUser.create(:user_id => self.id, :goal_id => goal.id)
    end
    c
  end

  def subscribe_course(course)
    c = CourseUser.where(:user_id => self.id, :course_id => course.id).first
    if c.nil?
      c = CourseUser.create(:user_id => self.id, :course_id => course.id)
      # CourseMailer.delay.course_registration_confirmation(self, course)
    end
    c
  end
end

