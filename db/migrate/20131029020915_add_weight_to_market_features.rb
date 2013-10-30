class AddWeightToMarketFeatures < ActiveRecord::Migration
  def change
    add_column :market_features, :weight, :integer, default: 0
  end
end
