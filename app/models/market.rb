class Market < ActiveRecord::Base
  # == Imports ==============================================================
  extend FriendlyId

  # == Slug =================================================================
  friendly_id :name, :use => [:history, :slugged]

  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :avatar, :hidden, :name, :slug, :slider, :content

  # == Relationships ========================================================
  # == Paperclip ============================================================
  has_attached_file :avatar,
                    :styles => {:full => '252x202#'},
                    :convert_options => {
                        :full => '-background black -gravity center -extent 252x202 -quality 75 -strip',
                    }

  # == Validations ==========================================================
  belongs_to :course

  # == Scopes ===============================================================
  scope :slider, -> { where(:slider => true) }
  scope :visible, -> { where(:hidden => false) }
  scope :hidden, -> { where(:hidden => true) }
  scope :with_course_and_owner, -> { includes(:course => :owner) }

  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
end
