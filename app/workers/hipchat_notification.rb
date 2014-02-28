class HipchatNotification
  include Sidekiq::Worker
  sidekiq_options queue: :notifications

  def perform(msg)
    return unless Rails.env.production?
    SendHipchatMessage.send(msg)
  end
end
