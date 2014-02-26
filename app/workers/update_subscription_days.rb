class UpdateSubscriptionDays
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform

    Subscription.where("last_update_day_count_at < ? or last_update_day_count_at is null", 1.day.ago).find_each do |sub|
      # how do we validate the subscription is in good standing?
      # for now, assume all subs are valid. We will setup the webhook later
      # TODO
      sub.last_update_day_count_at = sub.created_at if sub.last_update_day_count_at.nil?
      gap = Time.now - sub.last_update_day_count_at
      days = (gap / (60 * 60 * 24)).to_i

      sub.increment :subscribed_days, days
      sub.increment :total_days, days
      sub.touch :last_update_day_count_at
      sub.save!

    end
  end
end
