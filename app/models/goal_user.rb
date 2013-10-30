class GoalUser < ActiveRecord::Base
  # == Imports ==============================================================
  # == Slug =================================================================
  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :private, :user_id, :goal_id, :archived, :completed

  # == Relationships ========================================================
  belongs_to :user
  belongs_to :goal
  has_many :checkins, dependent: :destroy
  has_many :goal_user_jewels
  has_many :jewels, through: :goal_user_jewels
  has_many :activity_sender, as: :sender, class_name: 'Activity'
  has_many :goal_user_supporters
  has_many :supporters, through: :goal_user_supporters

  # == Paperclip ============================================================
  # == Validations ==========================================================
  # == Scopes ===============================================================
  scope :goal_mate_for, lambda { |goal| where(goal_id: goal.id, private: false).includes(:user) }

  scope :private_goal, lambda { |permission| where(private: permission) }

  scope :goal_for, lambda { |user| where(user_id: user.id) }

  scope :active, -> { where(archived: false, completed: false) }

  scope :archived, -> { where(archived: true, completed: false) }

  scope :finished, -> { where(archived: false, completed: true) }


  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
  def checkedin?
    !Checkin.where('created_at >= ? AND created_at <= ? AND goal_user_id = ?',
                   DateTime.now.beginning_of_day, DateTime.now.end_of_day, self.id).first.nil?
  end

  def to_activity_key
    if self.persisted?
      "#{self.class.name}-#{self.id}-goal-#{self.goal.id}"
    else
      "#{self.class.name}"
    end
  end

  def active?
    self.archived == false && self.completed == false
  end

  def complete!
    self.archived = false
    self.completed = true
    self.save!
  end

  def active!
    self.archived = false
    self.completed = false
    self.save!
  end

  def archive!
    self.archived = true
    self.completed = false
    self.save!
  end

  def checkin(thoughts)
    checkin = nil
    ActiveRecord::Base.transaction do
      checkin = Checkin.where('created_at >= ? AND created_at <= ? AND goal_user_id = ?',
                              DateTime.now.beginning_of_day, DateTime.now.end_of_day, self.id).first
      if checkin.nil?
        checkin = Checkin.create(thoughts: thoughts)
        self.checkins << checkin
        Activity.create(sender: self, trackable: checkin, share_key: self.to_activity_key, action: 'goal-user/checkin-create')
      end
    end
    checkin
  end

  def add_gem(gem)
    goal_user_jewel = GoalUserJewel.where(goal_id: self.goal.id, goal_user_id: self.id, jewel_id: gem.id).first
    if  goal_user_jewel.nil?
      GoalUserJewel.create!(goal_id: self.goal.id, goal_user_id: self.id, jewel_id: gem.id)
      Activity.create(sender: self, trackable: gem, share_key: self.to_activity_key, action: 'goal-user/jewel-create')
    end
  end

  def privacy_set_private

  end

  def privacy_set_public

  end

  def privacy_toggle
    self.private = !self.private
    self.save!
  end


end
