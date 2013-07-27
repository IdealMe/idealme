class GoalUser < ActiveRecord::Base
  # == Imports ==============================================================
  # == Slug =================================================================
  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :private

  # == Relationships ========================================================
  belongs_to :user
  belongs_to :goal
  has_many :checkins
  
  has_many :goal_user_jewels
  has_many :jewels, :through => :goal_user_jewels

  # == Paperclip ============================================================
  # == Validations ==========================================================
  # == Scopes ===============================================================
  scope :goal_mate_for, lambda { |goal| where(:goal_id => goal.id, :private => false).includes(:user) }

  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================


end
