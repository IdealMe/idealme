class Identity < ActiveRecord::Base
  # == Imports ==============================================================
  # == Slug =================================================================
  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :access_token, :identifier, :provider, :uid, :owner_id

  # == Relationships ========================================================
  belongs_to :owner, class_name: 'User'

  # == Paperclip ============================================================
  # == Validations ==========================================================
  # == Scopes ===============================================================
  scope :facebook_identity, lambda { |owner| where(owner_id: owner.id) }
  scope :google_identity, lambda { |owner| where(owner_id: owner.id) }
  
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
end