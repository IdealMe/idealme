class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :transaction_id
      t.string :subscriber_id
      
      t.text :parameters
      t.integer :status
      t.integer :cost, default: 0
      t.references :course
      t.references :market
      t.references :user

      t.integer :gateway
      t.string :card_firstname
      t.string :card_lastname
      t.string :card_email
      t.string :card_type
      t.integer :card_number_4
      t.integer :card_exp_year
      t.integer :card_exp_month
      
      t.string :billing_address1
      t.string :billing_address2
      t.string :billing_company
      t.string :billing_phone
      t.string :billing_zip
      t.string :billing_city
      t.string :billing_country
      t.string :billing_state
      t.timestamps
    end
    add_index :orders, :course_id
    add_index :orders, :user_id
  end
end
