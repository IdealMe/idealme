class Goal < ActiveRecord::Base
  # == Imports ==============================================================
  include Votable

  # == Slug =================================================================
  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :hidden, :name, :user_count, :avatar, :welcome, :hidden, :ordering, :category_id, :course_ids

  # == Relationships ========================================================
  has_many :goal_users
  has_many :users, :through => :goal_users

  belongs_to :category

  has_many :course_goals
  has_many :courses, :through => :course_goals

  # == Paperclip ============================================================
  has_attached_file :avatar,
                    :styles => {:full => '115x115#', :thumb => '30x30#'},
                    :convert_options => {
                        :full => ' -transparent white -gravity center -extent 115x115 -quality 75 -strip',
                        :thumb => ' -transparent white -gravity center -extent 30x30 -quality 75 -strip',

                    }

  # == Validations ==========================================================
  validates :name, :presence => true
  validates :name, :length => {:minimum => 1}


  # == Scopes ===============================================================
  scope :ordered, -> { order(:ordering) }
  scope :is_welcome, -> { where(:welcome => true) }
  scope :visible, -> { where(:hidden => false) }
  scope :hidden, -> { where(:hidden => true) }

  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
end