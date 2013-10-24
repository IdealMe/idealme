class CreateMarketFeatures < ActiveRecord::Migration
  def change
    create_table :market_features do |t|
      t.references :market
      t.text :description
      t.attachment :avatar
      t.timestamps
    end

    add_index :market_features, :market_id
  end
end
