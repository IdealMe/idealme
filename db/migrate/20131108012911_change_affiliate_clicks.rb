class ChangeAffiliateClicks < ActiveRecord::Migration
  def change
    rename_column :affiliate_clicks, :affiliate_tracking_id, :affiliate_link_id
  end
end
