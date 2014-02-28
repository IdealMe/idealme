class Market < ActiveRecord::Base
  # == Imports ==============================================================
  extend FriendlyId
  extend Forwardable

  def_delegators :course, :video_count, :document_count, :audio_count, :archive_count
  # == Slug =================================================================
  friendly_id :name, use: [:history, :slugged, :finders]

  # == Constants ============================================================
  # == Attributes ===========================================================

  # == Relationships ========================================================
  has_many :payloads, as: :payloadable, dependent: :destroy
  has_many :features, class_name: 'MarketFeature', dependent: :destroy
  belongs_to :course

  accepts_nested_attributes_for :features, allow_destroy: true

  # == Paperclip ============================================================
  has_attached_file :avatar,
                    styles: { full: '252x202#', thumb: '80x64#' },
                    s3_permissions: :public_read,
                    convert_options: {
                        full: '-gravity center -extent 252x202 -quality 75 -strip',
                        thumb: '-gravity center -extent 80x64 -quality 75 -strip'
                    }

  # == Validations ==========================================================
  validates :name, presence: true
  validates :name, length: { minimum: 1 }

  # == Scopes ===============================================================
  scope :slider, -> { where(slider: true) }
  scope :visible, -> { where(hidden: false) }
  scope :hidden, -> { where(hidden: true) }
  scope :with_course_and_owner, -> { includes(course: :owner) }
  scope :type_recommended, lambda { |user| }
  scope :type_trending, lambda { |user| }

  # == Callbacks ============================================================
  before_save :reject_blank_features
  # == Class Methods ========================================================
  # == Instance Methods =====================================================

  def reject_blank_features
    features.each do |feature|
      feature.destroy if feature.description.blank?
    end
  end
end
