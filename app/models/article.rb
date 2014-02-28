class Article < ActiveRecord::Base
  # == Imports ==============================================================
  extend FriendlyId
  include ActionView::Helpers::SanitizeHelper

  # == Slug =================================================================
  friendly_id :name, use: [:history, :slugged, :finders]

  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessor :author_id
  # == Relationships ========================================================
  has_many :payloads, as: :payloadable
  has_many :article_authors
  has_many :authors, through: :article_authors
  has_many :article_goals
  has_many :goals, through: :article_goals
  has_many :comments, as: :commentable, dependent: :destroy

  # == Paperclip ============================================================
  has_attached_file :image,
                    styles: { full: '252x202#', thumb: '126x93#' },
                    s3_permissions: :public_read,
                    convert_options: {
                        full: '-gravity center -extent 252x202 -quality 75 -strip',
                        thumb: '-gravity center -extent 80x64 -quality 75 -strip'
                    }
  # == Validations ==========================================================
  validates_length_of :name, :content, minimum: 2

  # == Scopes ===============================================================
  # == Callbacks ============================================================
  before_validation :clean_content

  # == Class Methods ========================================================
  # == Instance Methods =====================================================
  def clean_content
    self.content = content.gsub('<p>&nbsp;</p>', '') if content
  end

  def summary
    value = strip_tags(content)
    value.truncate(250)
  end

  def goals=(goal_ids)
    self.article_goals = goal_ids.reject(&:blank?)
      .map { |gid| Goal.where(id: gid).take }.compact
      .map { |goal| ArticleGoal.find_or_create_by(goal_id: goal.id, article_id: id) }
  end
end
