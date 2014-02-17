require 'spec_helper'
describe UpdateSubscriptionDays do

  let!(:worker) { UpdateSubscriptionDays.new }
  let!(:user) {create(:user)}
  let!(:subscription) {create(:subscription, user: user)}
  it "increments subscription days" do
    expect(subscription.subscribed_days).to eq 0
    expect(subscription.unsubscribed_days).to eq 0
    expect(subscription.total_days).to eq 0
  end

  it "is idempotent" do
    pending
  end
end
