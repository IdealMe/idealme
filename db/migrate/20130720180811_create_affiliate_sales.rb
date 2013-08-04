class CreateAffiliateSales < ActiveRecord::Migration
  def change
    create_table :affiliate_sales do |t|
      t.references :user
      t.references :order
      t.references :affiliate_tracking

      t.timestamps
    end
    add_index :affiliate_sales, :user_id
    add_index :affiliate_sales, :order_id
    add_index :affiliate_sales, :affiliate_tracking_id
  end
end
