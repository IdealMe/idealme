class Category < ActiveRecord::Base
  # == Imports ==============================================================
  extend FriendlyId

  # == Slug =================================================================
  friendly_id :name, :use => [:history, :slugged]

  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :name, :slug
  
  # == Relationships ========================================================
  has_many :courses
  has_many :goals
  #has_many :articles

  # == Paperclip ============================================================
  # == Validations ==========================================================
  validates_length_of :name, :minimum => 2
  validates :name, :presence => true
  validates :name, :uniqueness => true

  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  def self.for_select
    Category.all.collect { |category| [category.name, category.id] }
  end
  
  # == Instance Methods =====================================================

end
