
class NewOrderNotification
  include Sidekiq::Worker
  sidekiq_options queue: :notifications

  def perform(id)
    return unless Rails.env.production?
    order = Order.where(id: id).first
    if order
      SendHipchatMessage.send("New order: #{order.user.email} - $#{order.course.cost_in_dollars} - #{order.course.name}")
    end
  end
end
