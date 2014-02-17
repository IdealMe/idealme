class UpdateSubscriptionDays
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform

    Rails.logger.info "running update subscription days worker"

  end
end
