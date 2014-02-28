class PollQuestion < ActiveRecord::Base
  # == Imports ==============================================================
  # == Slug =================================================================
  # == Constants ============================================================
  # == Attributes ===========================================================
  # == Relationships ========================================================
  has_many :poll_choices
  has_many :poll_results

  accepts_nested_attributes_for :poll_choices, reject_if: lambda { |a| a[:name].blank? }, allow_destroy: true

  # == Paperclip ============================================================
  # == Validations ==========================================================
  validates :name, presence: true

  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  def self.compute_poll_question_tags
    payloads = {}
    PollQuestion.includes({ poll_choices: :poll_results }, :poll_results).find_each { |poll| payloads["{im:model:poll_question:#{poll.id}}"] = poll }
    payloads
  end

  # == Instance Methods =====================================================
  def total_votes
    if poll_results
      poll_results.length
    else
      0
    end
  end
end
