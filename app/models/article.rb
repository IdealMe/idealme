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
  belongs_to :category
  belongs_to :course

  has_many :payloads, as: :payloadable
  has_many :article_authors
  has_many :authors, through: :article_authors
  has_many :article_goals
  has_many :goals, through: :article_goals
  has_many :article_courses
  has_many :courses, through: :article_courses
  has_one :default_market, class_name: 'Market', foreign_key: 'id', primary_key: 'default_market_id'
  has_many :i_article_targets, foreign_key: 'article_source_id', class_name: 'ArticleVolume'
  has_many :article_targets, through: :i_article_targets, source: :article_target
  has_many :i_article_sources, foreign_key: 'article_target_id', class_name: 'ArticleVolume'
  has_many :article_sources, through: :i_article_sources, source: :article_source

  # == Paperclip ============================================================
  has_attached_file :image,
                    styles: {full: '252x202#', thumb: '126x93#'},
                    :s3_permissions => :public_read,
                    convert_options: {
                        full: '-gravity center -extent 252x202 -quality 75 -strip',
                        thumb: '-gravity center -extent 80x64 -quality 75 -strip'
                    }
  # == Validations ==========================================================
  validates_length_of :name, :content, minimum: 2

  # == Scopes ===============================================================
  # == Callbacks ============================================================
  before_validation :clean_content
  after_save :update_author

  # == Class Methods ========================================================
  # == Instance Methods =====================================================
  def clean_content
    self.content = self.content.gsub('<p>&nbsp;</p>', '') if self.content
  end

  def update_author
    user = User.where(id: self.author_id).first
    self.authors << user if user && !self.authors.include?(user)
  end

  def summary
    value = strip_tags(self.content)
    value.truncate(250)
  end

  def goals=(goal_ids)
    self.article_goals = goal_ids.reject(&:blank?)
      .map{|gid| Goal.where(id: gid).take }.compact
      .map{|goal| ArticleGoal.find_or_create_by(goal_id: goal.id, article_id: self.id) }
  end

end
