class AddToAweberList

  include Sidekiq::Worker
  sidekiq_options queue: :default

  def perform(user_id, list = 'idealmeoptin')
    return unless Rails.env.production?
    user = User.where(id: user_id).first
    user.add_to_aweber!(list)
  end
end
