class PollChoice < ActiveRecord::Base
  # == Imports ==============================================================
  # == Slug =================================================================
  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :name

  # == Relationships ========================================================
  belongs_to :poll_question
  has_many :poll_results

  # == Paperclip ============================================================
  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  # == Instance Methods =====================================================  
  def total_votes
    if self.poll_results
      self.poll_results.length
    else
      0
    end
  end
end
