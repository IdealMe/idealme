class AddSubscriptionToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :subscription_id, :integer
  end
end
