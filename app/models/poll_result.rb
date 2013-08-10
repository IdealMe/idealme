class PollResult < ActiveRecord::Base
  # == Imports ==============================================================
  # == Slug =================================================================
  # == Constants ============================================================
  # == Attributes ===========================================================    
  attr_accessible :owner_id, :poll_choice_id, :poll_question_id, :owner, :poll_question

  # == Relationships ========================================================
  belongs_to :owner, :class_name => 'User'
  belongs_to :poll_choice
  belongs_to :poll_question

  # == Paperclip ============================================================
  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================
end