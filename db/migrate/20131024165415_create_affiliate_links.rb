class CreateAffiliateLinks < ActiveRecord::Migration
  def change
    create_table :affiliate_links do |t|
      t.string :slug
      t.string :tracking_tag
      t.string :market_tag
      t.references :user


      t.timestamps
    end
  end
end
