class Course < ActiveRecord::Base
  # == Imports ==============================================================
  extend FriendlyId

  # == Slug =================================================================
  friendly_id :name, :use => [:history, :slugged]

  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :avatar, :hidden, :name, :slug, :owner_id, :cost, :default_market_id

  # == Relationships ========================================================
  has_many :markets

  has_one :default_market, :class_name => 'Market', :foreign_key => 'id', :primary_key => 'default_market_id', :dependent => :destroy

  belongs_to :owner, :class_name => 'User'

  has_many :course_users
  has_many :users, :through => :course_users

  has_many :sections
  has_many :lectures, :through => :sections

  # == Paperclip ============================================================
  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================


end
