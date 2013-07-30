class Market < ActiveRecord::Base
  # == Imports ==============================================================
  extend FriendlyId

  # == Slug =================================================================
  friendly_id :name, :use => [:history, :slugged]

  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :avatar, :hidden, :name, :slug, :slider, :content, :affiliate_tag

  # == Relationships ========================================================
  # == Paperclip ============================================================
  has_attached_file :avatar,
                    :styles => {:full => '252x202#', :thumb => '80x64#'},
                    :convert_options => {
                        :full => '-gravity center -extent 252x202 -quality 75 -strip',
                        :thumb => '-gravity center -extent 80x64 -quality 75 -strip'
                    }

  # == Validations ==========================================================
  belongs_to :course

  # == Scopes ===============================================================
  scope :slider, -> { where(:slider => true) }
  scope :visible, -> { where(:hidden => false) }
  scope :hidden, -> { where(:hidden => true) }
  scope :with_course_and_owner, -> { includes(:course => :owner) }

  scope :type_recommended, lambda {|user|}

  scope :type_trending, lambda {|user|}


  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
end
