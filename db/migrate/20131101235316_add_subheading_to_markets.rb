class AddSubheadingToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :subheader, :string
  end
end
