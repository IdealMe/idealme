class Checkin < ActiveRecord::Base
  # == Imports ==============================================================
  # == Slug =================================================================
  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :success, :goal_user_id

  # == Relationships ======================================================== 
  belongs_to :goal_user

  # == Paperclip ============================================================
  # == Validations ==========================================================
  # == Scopes ===============================================================
  scope :from_this_week, -> { where('created_at >= ? AND created_at <= ?',
                                    DateTime.now.beginning_of_week(start_day = :sunday),
                                    DateTime.now.end_of_week(start_day = :sunday)) }

  scope :last_n_week, lambda { |n| where('created_at >= ? AND created_at <= ?',
                                         DateTime.now.beginning_of_week(start_day = :sunday) - (n * 7).days,
                                         DateTime.now.end_of_week(start_day = :sunday)) }

  scope :for_goal_user, lambda { |goal_user| where(:goal_user_id => goal_user.id) }

  # == Callbacks ============================================================
  # == Class Methods ========================================================

  def self.start_date(n)
    DateTime.now.beginning_of_week(start_day = :sunday) - (n * 7).days
  end

  def self.end_date
    DateTime.now.end_of_week(start_day = :sunday)
  end

  # == Instance Methods =====================================================

  def today?
    self.created_at.to_datetime > DateTime.now.beginning_of_day
  end

end
