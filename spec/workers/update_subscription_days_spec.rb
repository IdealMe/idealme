require 'spec_helper'
describe UpdateSubscriptionDays do

  let!(:worker) { UpdateSubscriptionDays.new }
  let!(:user) {create(:user)}
  let!(:subscription) {create(:subscription, user: user, last_update_day_count_at: 36.hours.ago)}
  it "increments subscription days" do
    expect(subscription.subscribed_days).to eq 0
    expect(subscription.unsubscribed_days).to eq 0
    expect(subscription.total_days).to eq 0

    worker.perform

    subscription.reload
    expect(subscription.subscribed_days).to eq 1
    expect(subscription.last_update_day_count_at > 1.day.ago).to eq true

  end

  it "is idempotent" do
    # run it twice. don't double up the day counts
    subscription.last_update_day_count_at = 1.day.ago
    worker.perform
    worker.perform

    subscription.reload
    expect(subscription.subscribed_days).to eq 1
  end
end
