class CommentMailer < ActionMailer::Base
  default from: "questions@questions.idealme.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.comment_mailer.question.subject
  #
  def question(course, user, question, qid)
    @greeting = "Hi"
    @course   = course
    @user     = user
    @question = question

    recipients = [course.owner.email, 'questions@idealme.com']
    mail to: recipients, from: "#{course.slug}+#{qid}@questions.idealme.com"
  end
end
