class Goal < ActiveRecord::Base
  # == Imports ==============================================================
  # == Slug =================================================================
  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :hidden, :name, :user_count, :avatar, :welcome, :hidden, :ordering, :category_id

  # == Relationships ========================================================
  has_many :goal_users
  has_many :users, :through => :goal_users

  belongs_to :category

  has_many :goal_courses
  has_many :courses, :through => :goal_courses

  # == Paperclip ============================================================
  has_attached_file :avatar,
                    :styles => {:full => '115x115#'},
                    :convert_options => {
                        :full => ' -transparent white -gravity center -extent 115x115 -quality 75 -strip',
                    }

  # == Validations ==========================================================
  # == Scopes ===============================================================
  scope :ordered, -> { order(:ordering) }
  scope :is_welcome, -> { where(:welcome => true) }
  scope :visible, -> { where(:hidden => false) }
  scope :hidden, -> { where(:hidden => true) }

  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
end