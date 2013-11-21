class CommentMailer < ActionMailer::Base
  default from: "questions@questions.idealme.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.comment_mailer.question.subject
  #
  def question(course, user, question)
    @greeting = "Hi"
    @course   = course
    @user     = user
    @question = question

    recipients = ["charlie@idealme.com"]
    mail to: recipients, from: "#{course.slug}+#{question}@questions.idealme.com"
  end
end
