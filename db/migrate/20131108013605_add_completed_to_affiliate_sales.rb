class AddCompletedToAffiliateSales < ActiveRecord::Migration
  def change
    add_column :affiliate_sales, :completed, :boolean, :default => false
  end
end
