class Feedback < ActiveRecord::Base

  GENERAL_FEEDBACK = 1
  REQUEST_A_FEATURE = 2
  REPORT_A_PROBLEM = 3

  belongs_to :owner, :class_name => 'User'

  validates :content, :presence => true
  validates :feedback_type, :presence => true
  validates :owner_id, :presence => true

  def self.for_select
    [
        ['General Feedback', Feedback::GENERAL_FEEDBACK],
        ['Request a feature', Feedback::REQUEST_A_FEATURE],
        ['Report a problem', Feedback::REPORT_A_PROBLEM],
    ]
  end

  attr_accessible :content, :feedback_type, :owner_id, :owner
end
