class Article < ActiveRecord::Base
  # == Imports ==============================================================
  extend FriendlyId

  # == Slug =================================================================
  friendly_id :name, :use => [:history, :slugged]

  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :content, :default_market_id, :hidden, :name, :slug, :author_id, :category_id, :course_id, :goal_id
  attr_accessor :author_id

  # == Relationships ========================================================
  belongs_to :category
  belongs_to :course
  belongs_to :goal

  has_many :payloads, :as => :payloadable, :dependent => :destroy
  has_many :article_authors
  has_many :authors, :through => :article_authors, :dependent => :destroy
  has_many :article_courses
  has_many :courses, :through => :article_courses, :dependent => :destroy
  has_one :default_market, :class_name => 'Market', :foreign_key => 'id', :primary_key => 'default_market_id', :dependent => :destroy
  has_many :i_article_targets, :foreign_key => 'article_source_id', :class_name => 'ArticleVolume', :dependent => :destroy
  has_many :article_targets, :through => :i_article_targets, :source => :article_target
  has_many :i_article_sources, :foreign_key => 'article_target_id', :class_name => 'ArticleVolume', :dependent => :destroy
  has_many :article_sources, :through => :i_article_sources, :source => :article_source

  # == Paperclip ============================================================
  # == Validations ==========================================================
  validates_length_of :name, :content, :minimum => 2

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
    user = User.where(:id => self.author_id).first
    self.authors << user if user && !self.authors.include?(user)
  end

end