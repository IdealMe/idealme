class Section < ActiveRecord::Base
  # == Imports ==============================================================
  extend FriendlyId

  acts_as_list scope: :course

  # == Slug =================================================================
  friendly_id :name, use: [:history, :slugged, :finders]

  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :name, :slug, :course, :course_id, :content, :position, :description

  # == Relationships ========================================================
  belongs_to :course
  has_many :lectures

  # == Paperclip ============================================================
  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  def self.for_select
    Section.all.collect { |section| [section.name, section.id] }
  end

  # == Instance Methods =====================================================
end
