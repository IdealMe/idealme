class Reply < ActiveRecord::Base
  belongs_to :comment
  belongs_to :owner, class_name: 'User'

  after_create :notify_participants

  def notify_participants
    CommentMailer.activity_notification(participants, comment.id).deliver
  end

  def participants
    emails = []
    emails << comment.owner.email
    comment.replies.each { |r| emails << r.owner.email }
    emails.uniq - [owner.email]
  end
end
