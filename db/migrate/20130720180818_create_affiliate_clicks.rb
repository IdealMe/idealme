class CreateAffiliateClicks < ActiveRecord::Migration
  def change
    create_table :affiliate_clicks do |t|
      t.integer :clicks, default: 1
      t.string :ip
      t.string :user_agent
      t.string :tracking_code
      t.references :user
      t.references :affiliate_tracking

      t.timestamps
    end
    add_index :affiliate_clicks, :user_id
    add_index :affiliate_clicks, :affiliate_tracking_id
  end
end
