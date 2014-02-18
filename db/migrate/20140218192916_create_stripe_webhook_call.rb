class CreateStripeWebhookCall < ActiveRecord::Migration
  def change
    create_table :stripe_webhook_calls do |t|
      t.text :params
      t.boolean :processed, default: false
      t.timestamps
    end
  end
end
