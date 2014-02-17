class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|

      t.text :stripe_object
      t.integer :subscribed_days, default: 0
      t.integer :unsubscribed_days, default: 0
      t.integer :total_days, default: 0
      t.references :user
      t.datetime :last_update_day_count_at
      t.timestamps
    end
  end
end
