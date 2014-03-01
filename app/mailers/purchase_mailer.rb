class PurchaseMailer < ActionMailer::Base
  default from: 'info@idealme.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome(user)
    @greeting = "Hi #{user.fullname}"

    mail to: "#{user.email}"
  end

  def roger_love(user)
    mail to: "#{user.email}"
  end

  def workbook(order)
    @salutation   = order.user.fullname_or_username_or_id
    @order_number = order.id
    @order_date   = order.created_at.to_date.to_formatted_s(:long)

    mail to: "#{order.user.email}"
  end

  def subscribed(order)
    @salutation   = order.user.fullname_or_username_or_id
    @order_number = order.id
    @order_date   = order.created_at.to_date.to_formatted_s(:long)

    mail to: "#{order.user.email}"
  end

  def confirmed(order)
    @salutation   = order.user.fullname_or_username_or_id
    @order_number = order.id
    @order_date   = order.created_at.to_date.to_formatted_s(:long)
    @course_name  = order.course.name
    @course_price = order.course.cost_in_dollars
    @course       = order.course

    mail to: "#{order.user.email}"
  end
end
