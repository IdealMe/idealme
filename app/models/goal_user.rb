class GoalUser < ActiveRecord::Base
  # == Imports ==============================================================
  # == Slug =================================================================
  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :private, :user_id, :goal_id
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

  scope :private_goal, lambda { |permission| where(:private => permission) }

  scope :goal_for, lambda { |user| where(:user_id => user.id) }

  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
  def checkedin?
    !Checkin.where('created_at >= ? AND created_at <= ? AND goal_user_id = ?',
                   DateTime.now.beginning_of_day, DateTime.now.end_of_day, self.id).first.nil?
  end

  def checkin(thoughts)
    self.checkins << Checkin.create(:thoughts => thoughts) unless self.checkedin?
  end

  def add_gem(gem)
    GoalUserJewel.where(:goal_id => self.goal.id, :goal_user_id => self.id, :jewel_id => gem.id).first_or_create
  end
end
