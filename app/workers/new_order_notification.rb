
class NewOrderNotification
  include Sidekiq::Worker
  sidekiq_options queue: :notifications

  def perform(id)
    return unless Rails.env.production?
    order = Order.where(id: id).first
    if order && order.course?
      SendHipchatMessage.send("New course order: #{order.user.email} - $#{order.course.cost_in_dollars} - #{order.course.name}")
    elsif order && order.workbook?
      SendHipchatMessage.send("New workbook order: #{order.user.email}")
    elsif order && order.subscription?
      SendHipchatMessage.send("New subscription: #{order.user.email}")
    end
  end
end
