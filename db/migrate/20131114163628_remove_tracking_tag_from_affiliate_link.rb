class RemoveTrackingTagFromAffiliateLink < ActiveRecord::Migration
  def change
    remove_column :affiliate_links, :tracking_tag
  end
end
