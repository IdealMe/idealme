class Course < ActiveRecord::Base
  # == Imports ==============================================================
  extend FriendlyId
  include Votable

  # == Slug =================================================================
  friendly_id :name, use: [:history, :slugged, :finders]

  # == Constants ============================================================
  # == Attributes ===========================================================
  # == Relationships ========================================================
  has_many :markets, dependent: :destroy
  has_one :default_market, class_name: 'Market', foreign_key: 'id', primary_key: 'default_market_id', dependent: :destroy
  belongs_to :owner, class_name: 'User'
  has_many :course_users
  has_many :orders
  has_many :users, through: :course_users
  has_many :sections
  has_many :lectures, through: :sections
  has_many :reviews
  has_many :course_goals
  has_many :goals, through: :course_goals
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :replies, through: :comments
  has_many :votes, as: :votable
  has_many :payloads, as: :payloadable, dependent: :destroy

  accepts_nested_attributes_for :default_market

  # == Paperclip ============================================================
  has_attached_file :image,
                    styles: {full: '252x202#', thumb: '80x64#'},
                    :s3_permissions => :public_read,
                    convert_options: {
                        full: '-gravity center -extent 252x202 -quality 75 -strip',
                        thumb: '-gravity center -extent 80x64 -quality 75 -strip'
                    }

  has_attached_file :avatar,
                    styles: {full: '252x202#', thumb: '80x64#'},
                    :s3_permissions => :public_read,
                    convert_options: {
                        full: '-gravity center -extent 252x202 -quality 75 -strip',
                        thumb: '-gravity center -extent 80x64 -quality 75 -strip'
                    }
  # == Validations ==========================================================
  validates :name, presence: true
  validates :name, length: {minimum: 1}
  validates_inclusion_of :cost, in: 0..999999
  validates :default_market_id, presence: true

  # == Scopes ===============================================================
  scope :with_sections_and_lectures, -> { includes(sections: :lectures) }

  # == Callbacks ============================================================
  # == Class Methods ========================================================
  def self.for_select
    Course.all.collect { |course| [course.name, course.id] }
  end
  # == Instance Methods =====================================================

  def cost_in_dollars
    '%.2f' % (self.cost.to_i/100.0) # -> '0.10'
  end

  def cost_in_dollars=(v)
    self.cost = (v.to_f*100).to_i
  end

  def cost_in_dollars_without_cents
    "$#{self.cost.to_i / 100}"
  end

  def swipe_files
    self.payloads
  end

  def audio_count
    payloads_with_type(IM_PAYLOAD_AUDIO)
  end

  def video_count
    payloads_with_type(IM_PAYLOAD_VIDEO)
  end

  def document_count
    payloads_with_type(IM_PAYLOAD_DOCUMENT)
  end

  def archive_count
    payloads_with_type(IM_PAYLOAD_ARCHIVE)
  end

  def payloads_with_type(payload_type)
    payloads = self.lectures.map {|lecture| lecture.payloads.to_a }.flatten
    payloads.select {|payload| payload.intended_type == payload_type }.count
  end
end
