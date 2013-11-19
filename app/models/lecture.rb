class Lecture < ActiveRecord::Base
  # == Imports ==============================================================
  extend FriendlyId
  acts_as_list scope: :section

  # == Slug =================================================================
  friendly_id :name, use: [:history, :slugged, :finders]

  # == Constants ============================================================
  # == Attributes ===========================================================
  # == Relationships ========================================================
  belongs_to :section
  delegate :course, to: :section, allow_nil: true

  has_many :payloads, as: :payloadable, dependent: :destroy

  def lecture_type
    first_payload = self.payloads.first
    if first_payload
      case first_payload.intended_type
      when IM_PAYLOAD_DOCUMENT
        :document
      when IM_PAYLOAD_VIDEO
        :video
      when IM_PAYLOAD_ARCHIVE
        :archive
      when IM_PAYLOAD_IMAGE
        :image
      when IM_PAYLOAD_AUDIO
        :audio
      end
    end
  end

  # == Paperclip ============================================================
  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
end
