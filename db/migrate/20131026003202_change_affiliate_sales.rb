class ChangeAffiliateSales < ActiveRecord::Migration

  def change
    #rename_column :affiliate_sales, :affiliate_tracking_id, :affiliate_link_id
    #remove_index :affiliate_sales, :affiliate_tracking_id
    add_index :affiliate_sales, :affiliate_link_id
  end

end
