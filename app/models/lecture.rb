class Lecture < ActiveRecord::Base
  # == Imports ==============================================================
  extend FriendlyId
  acts_as_list scope: :section

  # == Slug =================================================================
  friendly_id :name, use: [:history, :slugged, :finders]

  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :name, :slug, :section, :section_id, :content, :description, :position

  # == Relationships ========================================================
  belongs_to :section
  delegate :course, to: :section, allow_nil: true

  has_many :payloads, as: :payloadable, dependent: :destroy

  # == Paperclip ============================================================
  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
end
