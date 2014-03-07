class AddProductToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :product, :string
  end
end
