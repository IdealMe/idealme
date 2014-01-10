class NewUserNotification
  include Sidekiq::Worker
  sidekiq_options queue: :notifications

  def perform(id)
    user = User.where(id: id).first
    if user
      SendHipchatMessage.send("New user registration: #{user.email} - #{user.id}")
    end
  end
end
