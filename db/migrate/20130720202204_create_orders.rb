class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :transaction_id
      t.string :transaction_status
      t.text :ipn
      t.integer :status
      t.string :subscriber_id
      t.integer :cost
      t.references :course, :default => 0
      t.references :user

      t.timestamps
    end
    add_index :orders, :course_id
    add_index :orders, :user_id
  end
end
