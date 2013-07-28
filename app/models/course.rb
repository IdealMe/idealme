class Course < ActiveRecord::Base
  # == Imports ==============================================================
  extend FriendlyId

  # == Slug =================================================================
  friendly_id :name, :use => [:history, :slugged]

  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :avatar, :hidden, :name, :slug, :owner_id, :cost, :default_market_id,
                  :review_positive, :review_negative

  # == Relationships ========================================================
  has_many :markets

  has_one :default_market, :class_name => 'Market', :foreign_key => 'id', :primary_key => 'default_market_id', :dependent => :destroy

  belongs_to :owner, :class_name => 'User'

  has_many :course_users
  has_many :users, :through => :course_users

  has_many :sections
  has_many :lectures, :through => :sections

  has_many :reviews

  has_many :course_goals
  has_many :goals, :through => :course_goals

  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :replies, :through => :comments

  # == Paperclip ============================================================
  # == Validations ==========================================================
  # == Scopes ===============================================================
  scope :with_sections_and_lectures, -> { includes(:sections => :lectures) }

  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
end
