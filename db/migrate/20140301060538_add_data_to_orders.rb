class AddDataToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :data, :json
  end
end
