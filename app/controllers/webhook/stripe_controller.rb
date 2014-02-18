class Webhook::StripeController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def notify
    Rails.logger.debug "STRIPE WEBHOOK"
    Rails.logger.debug params
    head :ok
  end
end
