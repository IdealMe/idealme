class Activity < ActiveRecord::Base
  # == Imports ==============================================================
  serialize :parameters

  # == Slug =================================================================
  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :action, :count, :share_key, :parameters, :read, :sender, :trackable, :sender_id, :sender_type

  # == Relationships ========================================================
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :replies, :through => :comments
  belongs_to :sender, :polymorphic => true
  belongs_to :trackable, :polymorphic => true

  # == Paperclip ============================================================
  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
end
