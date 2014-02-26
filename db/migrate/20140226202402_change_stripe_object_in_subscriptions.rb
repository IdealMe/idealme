class ChangeStripeObjectInSubscriptions < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :stripe_object
    add_column :subscriptions, :stripe_object, :json
  end
end
