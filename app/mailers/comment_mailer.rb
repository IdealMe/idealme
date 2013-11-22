class CommentMailer < ActionMailer::Base
  default from: "questions@questions.idealme.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.comment_mailer.question.subject
  #
  def question(course, user, question, qid)
    @course   = course
    @user     = user
    @question = question

    recipients = [course.owner.email, 'questions@idealme.com']
    mail to: recipients, from: "#{course.slug}+#{qid}@questions.idealme.com"
  end

  def activity_notification(emails, cid, rid)
    comment = Comment.find cid
    reply = Reply.find rid
    @username = reply.owner.username
    mail(to: "questions@idealme.com", bcc: emails, from: "#{course.slug}+#{cid}@questions.idealme.com")
  end
end
