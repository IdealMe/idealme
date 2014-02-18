class Webhook::StripeController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def notify
    Rails.logger.debug "STRIPE WEBHOOK"
    Rails.logger.debug params
    swc = StripeWebhookCall.new
    swc.params = params.to_s
    swc.save!
    head :ok
  end
end
