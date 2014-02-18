class UpdateSubscriptionDays
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform

    Rails.logger.info "running update subscription days worker"

    Subscription.where("last_update_day_count_at < ?", 1.day.ago).find_each do |sub|
      # how do we validate the subscription is in good standing?
      # for now, assume all subs are valid. We will setup the webhook later
      # TODO

      sub.increment :subscribed_days
      sub.increment :total_days
      sub.touch :last_update_day_count_at
      sub.save!

    end
  end
end
